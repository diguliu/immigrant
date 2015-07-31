require 'immigrant/smuggler'

class Immigrant::Plan
  # This method should be overriden on the subclasses
  def initialize(project, version, execution)
    @smuggler = Immigrant::Smuggler.new(args[:project], args[:version])
  end

  def execute
    @
  end
end
