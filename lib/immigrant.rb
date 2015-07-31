require 'yaml'

module Immigrant
  # Configuration defaults
  @config = {}

  def self.require_entities
    Dir.glob(File.join(config[:entities_folder], '*.rb')).each {|entity| require entity}
  end

  # Configure through hash
  def self.configure(opts = {})
    opts.each { |k,v| @config[k.to_sym] = v }
    #require_entities
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end
end

require "immigrant/version"
require "immigrant/tasks_loader"
#require 'immigrant/record'
