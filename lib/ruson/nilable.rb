module Ruson
  module Nilable
    def check_nilable(value, options)
      return unless nilable?(options)
      raise Ruson::NotNilException if value.nil?
    end

    private

    def nilable?(options)
      options[:nilable]
    end
  end
end