require 'json'

class Immigrant::Memory
  DATA_PATH = 'data'

  def initialize(project, identifier=Time.now.to_i)
    @file_path = File.join(DATA_PATH, project, "memory-#{identifier}.json")
    file = File.exist?(@file_path) ? File.open(@file_path, 'r') : nil
    if file
      @data = JSON.parse(file.read)
    else
      @data= {}
    end
  end

  attr_reader :data, :file_path

  def set(source, target)
    @data[source.memory_namespace] = {} if !data.has_key?(source.memory_namespace)
    @data[source.memory_namespace][source.id.to_s] = target.id.to_s
  end

  def read(source)
    return if !data.has_key?(source.memory_namespace)
    @data[source.memory_namespace][source.id.to_s]
  end

  def remove(source)
    return if !data.has_key?(source.memory_namespace)
    @data[source.memory_namespace].delete(source.id.to_s)
  end

  def check(source)
    return if !data.has_key?(source.memory_namespace)
    @data[source.memory_namespace].has_key?(source.id.to_s)
  end

  def write
    dirname = File.dirname(file_path)
    Dir.mkdir(dirname) unless File.directory?(dirname)

    persistent_memory = File.open(file_path,'w')
    persistent_memory.write(data.to_json)
    persistent_memory.close
  end
end
