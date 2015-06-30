require 'progressbar'
require 'immigrant/memory'
require 'immigrant/error'

class Immigrant::Smuggler
  def initialize(project, identifier)
    @project = project
    @identifier = identifier
    @memory =  Immigrant::Memory.new(@project, @identifier)
  end

  attr_reader :memory

  def avoid_migration?(foreigner)
    memory.check(foreigner) ||
    foreigner.class.exceptions.include?(foreigner.id)
  end

  def run_migration(klass, sample = 0)
    @error_log = Immigrant::Error.new(klass, @identifier)
    base_sample = sample
    total = sample > 0 ? sample : klass.count(klass.primary_key)
    pbar = ProgressBar.new("#{klass.name.split('::').last}", total)
    failed = 0

    klass.find_each do |source_entity|
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
      klass.find_each do |source_entity|
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
