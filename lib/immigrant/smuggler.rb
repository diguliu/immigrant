require 'progressbar'
require 'immigrant/memory'
require 'immigrant/error'

class Immigrant::Smuggler
  def initialize(project, identifier, plan)
    @project = project
    @identifier = identifier
    @plan = plan
    @memory =  Immigrant::Memory.new(@project, @identifier)
  end

  attr_reader :memory

  def migrate
    @plan.each do |action|
      klass = action[:klass].constantize
      scope = action[:scope].present? ? eval(action[:scope]) : klass
      sample = action[:sample] || 0
      options ||= {}
      options[:kind] ||= :linear
      options[:sample] ||= 0
      run_migration(klass, scope, options)
    end
  end

  def avoid_migration?(foreigner)
    memory.check(foreigner) ||
    foreigner.class.exceptions.include?(foreigner.id)
  end

  def linear_migration(scope, pbar, options)
    sample = options[:sample]
    failed = 0
    scope.find_each do |source_entity|
      begin
        next if avoid_migration?(source_entity)
        target_entity = source_entity.migrate(memory)
        memory.set(source_entity, target_entity) if target_entity.present? && source_entity.memory_namespace.present?
      rescue Exception => exception
        failed += 1
        @error_log.log(source_entity, exception)
      end
      pbar.inc
      sample -= 1
      break if sample == 0
    end

    return failed
  end

  def tree_migrate(list, children_method, failed)
    list.find_each do |source_entity|
      begin
        next if avoid_migration?(source_entity)
        target_entity = source_entity.migrate(memory)
        memory.set(source_entity, target_entity) if target_entity.present? && source_entity.memory_namespace.present?
        pbar.inc
        failed = tree_migrate(source_entity.send(children_method), children_method, failed)
      rescue Exception => exception
        failed += 1
        @error_log.log(source_entity, exception)
        pbar.inc
      end
    end
    return failed
  end

  def tree_migration(scope, pbar, options)
    failed = 0
    failed = tree_migrate(scope.where(options[:root_conditions]), options[:children_method], failed)
    return failed
  end

  def run_migration(klass, scope = nil, options = {})
    sample = options[:sample]
    @error_log = Immigrant::Error.new(klass, @identifier)
    base_sample = sample
    total = sample > 0 ? sample : scope.count(klass.primary_key)
    pbar = ProgressBar.new("#{klass.name.split('::').last}", total)

    failed = self.send("#{options[:kind]}_migration", scope, pbar, options)

    pbar.finish
    memory.write
    if failed > 0
      puts ">> #{failed}/#{total} failed entities migration!"
      puts "   Check more information about it on: #{@error_log.file_path}"
    else
      puts ">> Migration completed without errors."
    end

    @error_log = Immigrant::Error.new(klass, @identifier+'-pos-migrate')
    pbar = ProgressBar.new("#{klass.name.split('::').last} pos-migrate", total)
    failed = 0
    sample = base_sample

    begin
      klass.new.method(:pos_migrate)
      scope.find_each do |source_entity|
        begin
          next if source_entity.class.exceptions.include?(source_entity.id)
          next if memory.read(source_entity).blank?
          target_entity = source_entity.pos_migrate(memory)
        rescue Exception => exception
          failed += 1
          @error_log.log(source_entity, exception)
        end
        pbar.inc
        sample -= 1
        break if sample == 0
      end
    rescue NameError
    end

    pbar.finish
    if failed > 0
      puts ">> #{failed}/#{total} failed entities pos-migration!"
      puts "   Check more information about it on: #{@error_log.file_path}"
    else
      puts ">> Migration completed without errors."
    end
  end
end
