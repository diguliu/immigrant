require 'immigrant/smuggler'

load 'schema.rb'
require 'lib/foreigner'
require 'lib/native'

RSpec.configure do |config|
  config.before(:each, :memory => :example) do
  end
end

RSpec.describe Immigrant::Smuggler do
  it 'initializes a smuggler with memory' do
    smuggler = Immigrant::Smuggler.new('imperialist-attack', 'syria')

    expect(smuggler.memory).not_to eq(nil)
  end

  it 'avoids migrating already migrated foreigners' do
    smuggler = Immigrant::Smuggler.new('imperialist-attack', 'syria')
    foreigner = Foreigner.new(:id => 1)
    native = Native.new(:id => 3)
    smuggler.memory.set(foreigner, native)

    expect(smuggler.avoid_migration?(foreigner)).to eq(true)
  end

  it 'avoids migrating exceptional foreingers' do
    smuggler = Immigrant::Smuggler.new('imperialist-attack', 'syria')
    foreigner = Foreigner.new(:id => 6)
    native = Native.new(:id => 3)

    expect(smuggler.avoid_migration?(foreigner)).to eq(true)
  end
end
