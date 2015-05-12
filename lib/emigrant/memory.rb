class Emigrant::Memory
  @@memory = {}
  @@file_path = nil

  class << self
    def memory
      @@memory
    end

    def file_path
      @@file_path
    end

    def prepare(timestamp)
      @@file_path = File.join('/var', 'lib', 'emigrant', "migration-memory-#{timestamp}.json")
      file = File.exist?(@@file_path) ? File.open(@@file_path, 'r') : nil
      if file.blank?
        @@memory = {}
      else
        @@memory = ActiveSupport::JSON.decode(file.read)
      end
    end

    def set(source, target)
      @@memory[source.memory_namespace] = {} if !@@memory.has_key?(source.memory_namespace)
      @@memory[source.memory_namespace][source.id.to_s] = target.id.to_s
    end

    def read(source)
      return if !@@memory.has_key?(source.memory_namespace)
      @@memory[source.memory_namespace][source.id.to_s]
    end

    def remove(source)
      return if !@@memory.has_key?(source.memory_namespace)
      @@memory[source.memory_namespace].delete(source.id.to_s)
    end

    def check(source)
      return if !@@memory.has_key?(source.memory_namespace)
      @@memory[source.memory_namespace].has_key?(source.id.to_s)
    end

    def write
      persistent_memory = File.open(@@file_path,'w')
      persistent_memory.write(@@memory.to_json)
      persistent_memory.close
    end
  end
end
