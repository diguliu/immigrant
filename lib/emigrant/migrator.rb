require_dependency 'progressbar'

class Emigrant::Migrator
  def initialize(identifier)
    @identifier = identifier
    Emigrant::Memory.prepare(@identifier)
  end

  def run_migration(klass, sample = 0)
    @error_log = Emigrant::Error.new(klass, @identifier)
    total = sample > 0 ? sample : klass.count(klass.primary_key)
    pbar = ProgressBar.new("#{klass.name.split('::').last}", total)
    failed = 0

    klass.find_each do |source_entity|
      begin
        next if source_entity.class.exceptions.include?(source_entity.id)
        next if Emigrant::Memory.read(source_entity).present?
        target_entity = source_entity.migrate
        Emigrant::Memory.set(source_entity, target_entity) if target_entity.present? && source_entity.memory_namespace.present?
      rescue Exception => exception
        failed += 1
        @error_log.log(source_entity, exception)
      end
      pbar.inc
      sample -= 1
      break if sample == 0
    end

    pbar.finish
    Emigrant::Memory.write
    if failed > 0
      puts ">> #{failed}/#{total} failed entities migration!"
      puts "   Check more information about it on: #{@error_log.file_path}"
    else
      puts ">> Migration completed without errors."
    end

    @error_log = Emigrant::Error.new(klass, @identifier+'-pos-migrate')
    pbar = ProgressBar.new("#{klass.name.split('::').last} pos-migrate", total)
    failed = 0

    begin
      klass.new.method(:pos_migrate)
      klass.find_each do |source_entity|
        begin
          next if source_entity.class.exceptions.include?(source_entity.id)
          target_entity = source_entity.pos_migrate
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
