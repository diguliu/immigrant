require 'yaml'
require 'immigrant/smuggler'

namespace :immigrant do
  task :migrate, [:project, :version] => :environment do |t, args|
    plan_file = File.join(Immigrant.config[:plans_folder], "#{args[:project]}-#{args[:version]}.yml")
    plan = YAML.load_file(plan_file)
    smuggler = Immigrant::Smuggler.new(args[:project], args[:version], plan)
    smuggler.migrate
  end
end
