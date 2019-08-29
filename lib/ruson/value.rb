module Ruson
  module Value
    def get_val(params, key_name, options)
      check_nilable(params[key_name], options[:nilable])
      if !options[:class].nil?
        class_param(params[key_name], options[:class])
      elsif !options[:each_class].nil?
        each_class_param(params[key_name], options[:each_class])
      else
        params[key_name]
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

    def check_nilable(value, nilable)
      if nilable
        raise Ruson::NotNilException if value.nil?
      end
    end
  end
end
