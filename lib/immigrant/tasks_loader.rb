class Immigrant::TasksLoader < Rails::Railtie
  rake_tasks do
    path = File.join(File.dirname(__FILE__), '..', 'tasks','*.rake')
    files = Dir.glob(path)
    files.each { |f| load f }
  end
end
