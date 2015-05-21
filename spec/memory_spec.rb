require 'immigrant/memory'

RSpec.configure do |config|
  config.before(:each, :memory => :example) do
    @source = double('source', :memory_namespace => 'records', :id => 1)
    @target = double('target', :id => 2)
    @memory = Immigrant::Memory.new('startrek', 'v1')
    @memory.set(@source, @target)
  end

  config.after(:each, :data => :write) do
    data_path = Dir.glob(File.join(Immigrant::Memory::DATA_PATH, '*'))
    FileUtils.rm_rf(data_path)
  end
end

RSpec.describe Immigrant::Memory do
  it 'initializes the memory with an empty hash if no file given' do
    memory = Immigrant::Memory.new('startrek')

    expect(memory.data).to eq({})
  end

  it 'sets the element map', :memory => :example do
    expect(@memory.data).to eq({@source.memory_namespace => {@source.id.to_s => @target.id.to_s}})
  end

  it 'gets target by source', :memory => :example do
    expect(@memory.read(@source)).to eq(@target.id.to_s)
  end

  it 'checks source', :memory => :example do
    expect(@memory.check(@source)).to eq(true)
  end

  it 'removes source', :memory => :example do
    @memory.remove(@source)
    expect(@memory.check(@source)).to eq(false)
  end

  it 'writes data to file', :memory => :example, :data => :write do
    @memory.write
    reloaded_memory = Immigrant::Memory.new('startrek', 'v1')
    expect(reloaded_memory.data).to eq(@memory.data)
  end
end
