module Ruson
  module Nilable
    def check_nilable(params, key_name, options)
      if options[:nilable]
        raise Ruson::NotNilException if params[key_name].nil?
      end
    end
  end
end