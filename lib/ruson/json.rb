module Ruson
  module Json
    def get_hash_from_json(json)
      return unless json
      return json if json.class == ActiveSupport::HashWithIndifferentAccess

      (json.class == Hash ? json : JSON.parse(json)).with_indifferent_access
    end

    #
    # Returns the ID from the JSON file path.
    #
    def id_from_file_path(path)
      File.basename(path, '.json').to_i
    end
  end
end
