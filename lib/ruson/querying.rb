module Ruson
  module Querying
    def self.included(klass)
      klass.extend(ClassMethods)
      klass.extend(Ruson::Json)
    end

    module ClassMethods
      def all
        ensure_output_folder_is_defined

        model_files.collect do |path|
          json = JSON.parse(File.read(path))

          new(json.merge(id: id_from_file_path(path)))
        end
      end

      def find(id)
        ensure_output_folder_is_defined

        file_path = File.join(model_base_path, "#{id}.json")

        return unless File.exist?(file_path)

        load(file_path, id: id)
      end

      def find!(id)
        record = find(id)

        raise Ruson::RecordNotFound unless record

        record
      end

      def first
        ensure_output_folder_is_defined

        file_path = model_files.first

        return unless file_path

        id = id_from_file_path(file_path)

        load(file_path, id: id)
      end

      def first!
        record = first

        raise Ruson::RecordNotFound unless record

        record
      end

      def load(file_path, extra_json = {})
        json = JSON.parse(File.read(file_path))

        json.merge!(extra_json) if extra_json

        new json
      end

      def where(attributes)
        ensure_output_folder_is_defined

        query_attributes = attributes.stringify_keys

        models = model_files.collect do |path|
          json = JSON.parse(File.read(path))

          query_attributes_matches = query_attributes.keys.all? do |key|
            json[key] == query_attributes[key]
          end

          if query_attributes_matches
            new(json.merge(id: id_from_file_path(path)))
          end
        end.compact

        Array(models)
      end

      def model_files
        Dir.glob(File.join(model_base_path, '*.json'))
      end
    end
  end
end
