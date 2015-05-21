require 'immigrant/record'

class Foreigner < Immigrant::Record

  def self.exceptions
    [6, 9]
  end

  def memory_namespace
    'foreigner'
  end

  def fallback_name
    'Pablo'
  end

  def fallback_document
    'Self-signed card'
  end

  def __age
    years_lived < 18 ? 18 : years_lived
  end
end
