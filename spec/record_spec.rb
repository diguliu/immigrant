load 'schema.rb'

require 'lib/starship'
require 'lib/localship'

RSpec.describe Emigrant::Record do
  it 'includes subclasses on entities list' do
    expect(Emigrant::Record.entities).to include(Starship)
  end

  it 'sets fallback attributes when validation fails' do
    localship = Localship.new
    localship.valid?
    expect(localship.valid?).to eq(false)

    starship = Starship.new
    localship = starship.set_fallback_attributes(localship)

    expect(localship.name).to eq(starship.fallback_name)
    expect(localship.phasers).to eq(starship.fallback_phasers)
    expect(localship.valid?).to eq(true)
  end

  it 'sets a attribute by fetching the attribute with the same name' do
    localship = Localship.new
    starship = Starship.new(:name => 'Enterprise')
    localship = starship.set_attributes(localship, [:name])

    expect(localship.name).to eq(starship.name)
  end

  it 'sets a attribute with pretreatment of __' do
    localship = Localship.new
    starship = Starship.new(:foton_torpedoes => 2)
    localship = starship.set_attributes(localship, [:torpedoes])

    expect(localship.torpedoes).to eq(starship.__torpedoes)
  end

  it 'provides a new record with the defined attributes' do
    starship = Starship.new(:name => 'Enterprise', :phasers => 2)
    localship = starship.new_record(Localship, [:name, :phasers])

    expect(localship.class).to eq(Localship)
    expect(localship.name).not_to eq(nil)
    expect(localship.phasers).not_to eq(nil)
  end

  it 'creates a new record with the defined attributes' do
    starship = Starship.new(:name => 'Enterprise', :phasers => 2)
    localship = starship.create_record(Localship, [:name, :phasers])

    expect(localship.class).to eq(Localship)
    expect(localship.name).not_to eq(nil)
    expect(localship.phasers).not_to eq(nil)
  end
end
