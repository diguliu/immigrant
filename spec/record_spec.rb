load 'schema.rb'

require 'lib/native'
require 'lib/foreigner'

RSpec.describe Immigrant::Record do
  it 'includes subclasses on entities list' do
    expect(Immigrant::Record.entities).to include(Foreigner)
  end

  it 'sets fallback attributes when validation fails' do
    native = Native.new
    native.valid?
    expect(native.valid?).to eq(false)

    foreigner = Foreigner.new
    native = foreigner.set_fallback_attributes(native)

    expect(native.name).to eq(foreigner.fallback_name)
    expect(native.document).to eq(foreigner.fallback_document)
    expect(native.valid?).to eq(true)
  end

  it 'sets a attribute by fetching the attribute with the same name' do
    native = Native.new
    foreigner = Foreigner.new(:name => 'Maria')
    native = foreigner.set_attributes(native, [:name])

    expect(native.name).to eq(foreigner.name)
  end

  it 'sets a attribute with pretreatment of __' do
    native = Native.new
    foreigner = Foreigner.new(:years_lived => 15)
    native = foreigner.set_attributes(native, [:age])

    expect(native.age).to eq(foreigner.__age)
  end

  it 'provides a new record with the defined attributes' do
    foreigner = Foreigner.new(:name => 'Jose', :years_lived => 22)
    native = foreigner.new_record(Native, [:name, :age])

    expect(native.class).to eq(Native)
    expect(native.name).not_to eq(nil)
    expect(native.age).not_to eq(nil)
  end

  it 'creates a new record with the defined attributes' do
    foreigner = Foreigner.new(:name => 'Jose', :years_lived => 22)
    native = foreigner.create_record(Native, [:name, :age])

    expect(native.class).to eq(Native)
    expect(native.name).not_to eq(nil)
    expect(native.age).not_to eq(nil)
  end
end
