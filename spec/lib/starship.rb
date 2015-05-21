require 'emigrant/record'

class Starship < Emigrant::Record
  def fallback_name
    'Unknown ship'
  end

  def fallback_phasers
    4
  end

  def __torpedoes
    foton_torpedoes
  end

  def __phasers
    phasers*2
  end
end
