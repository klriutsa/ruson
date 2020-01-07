module Ruson
  module Converter
    def convert_to_hash(accessors)
      accessors.keys.inject({ id: id }) do |result, key|
        value = send(key)
        result[key.to_sym] = convert_array_to_hash_value(value)
        result
      end
    end

    private

    def convert_array_to_hash_value(value)
      if value.instance_of?(::Array)
        value.inject([]) { |result, v| result << convert_ruson_to_hash_value(v) }
      else
        convert_ruson_to_hash_value(value)
      end
    end

    def convert_ruson_to_hash_value(value)
      return value.to_hash if ruson_class?(value)
      value
    end

    def ruson_class?(value)
      value.class < Ruson::Base
    end
  end
end
