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

        json = JSON.parse(File.read(file_path))
        json[:id] = id

        new json
      end

      def find!(id)
        record = find(id)

        raise Ruson::RecordNotFound unless record

        record
      end
    end
  end
end
