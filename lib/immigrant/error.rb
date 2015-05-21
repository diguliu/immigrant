class Immigrant::Error
  attr_accessor :file_path

  def initialize(klass, timestamp)
    kind = klass.name.underscore.gsub('/', '-')
    self.file_path = File.join('/var', 'log', 'immigrant', "errors-#{kind}-#{timestamp}.log")
  end

  def log(entity, exception)
    message = exception.to_s
    backtrace = exception.backtrace.join("\n")
    log = File.open(file_path, 'a')
    log.write(">> [#{entity.class}] #{entity.id}\t#{message}\n#{backtrace}\n")
    log.flush
  end
end
