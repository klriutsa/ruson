module Ruson
  module Querying
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
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

        file_path = Dir.glob(File.join(model_base_path, '*.json')).first

        return unless file_path

        id = File.basename(file_path, '.json').to_i

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
    end
  end
end
