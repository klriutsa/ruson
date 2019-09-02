module Ruson
  module Nilable
    def check_nilable(value, options)
      return if nilable?(options)
      raise Ruson::NotNilException if value.nil?
    end

    private

    def nilable?(options)
      nilable = options[:nilable]
      return true if nilable.nil?
      nilable
    end
  end
end