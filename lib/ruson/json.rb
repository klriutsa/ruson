module Ruson
  module Json
    def get_hash_from_json(json)
      return unless json
      return json if json.class == ActiveSupport::HashWithIndifferentAccess

      (json.class == Hash ? json : JSON.parse(json)).with_indifferent_access
    end
  end
end
