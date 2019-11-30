module Ruson
  module Persistence
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def create(*args)
        new_record = new(*args)
        new_record.save
        new_record
      end

      def model_base_path
        File.join(Ruson.output_folder, "#{self.name}s")
      end
    end

    def delete_file_from_disk
      FileUtils.rm_f(model_path)
    end

    def destroy
      delete_file_from_disk
      true
    end

    def ensure_output_folder_is_defined
      return if Ruson.output_folder

      raise ArgumentError, 'No output folder defined. You can define it ' \
                           'using Ruson.output_folder = "/path/to/db/folder"'
    end

    def ensure_model_folder_exists
      return if File.exist?(self.class.model_base_path)

      FileUtils.mkdir_p(self.class.model_base_path)
    end

    def generate_uniq_id
      ensure_model_folder_exists

      return if id

      id = 0

      Dir.glob(File.join(self.class.model_base_path, '*.json')).each do |file|
        file_id = File.basename(file, '.json').to_i

        id = file_id if file_id > id
      end

      self.id = id + 1
    end

    def model_path
      File.join(self.class.model_base_path, "#{id}.json")
    end

    def write_file_to_disk
      File.open(model_path, 'w') do |file|
        file.write(to_json)
      end
    end

    def save
      ensure_output_folder_is_defined
      generate_uniq_id
      write_file_to_disk
      true
    end

    def update(attributes)
      attributes.symbolize_keys!

      # Takes only accessor for attributes to be updated, avoiding to nullify
      # the other attributes.
      filtered_accessors = self.class.accessors.select do |key, accessor_attrs|
        attributes.key?(key) || attributes.key?(accessor_attrs[:name])
      end

      update_attributes(filtered_accessors, attributes)

      save
    end
  end
end

