module Ruson
  module Value
    def get_val(value, options)
      if !options[:class].nil?
        class_param(value, options[:class])
      elsif !options[:each_class].nil?
        each_class_param(value, options[:each_class])
      else
        value
      end
    end

    private

    def class_param(param, klass)
      return nil if param.nil?
      klass.new(param)
    end

    def each_class_param(params, klass)
      return nil if params.nil?
      params.inject([]) do |result, param|
        result << class_param(param, klass)
        result
      end
    end
  end
end
