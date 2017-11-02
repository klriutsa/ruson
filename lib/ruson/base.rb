require 'json'

module Ruson
  class Base
    def initialize(json, options={})
      params = JSON.parse(json)
      params = params[options[:root].to_s] unless options[:root].nil?
      @params = params
      fields
    end

    def fields

    end

    def field(attr, options={})
      attr_name = attr.to_s
      key_name = options[:name] || attr_name
      self.class.class_eval("attr_accessor :#{attr_name}")
      val = get_val(key_name, options)
      set_attribute(attr_name, val)
    end

    private

    def set_attribute(attr_name, val)
      self.send("#{attr_name}=".to_sym, val)
    end

    def get_val(key_name, options)
      if !options[:class].nil?
        class_param(@params[key_name], options[:class])
      elsif !options[:each_class].nil?
        each_class_param(@params[key_name], options[:each_class])
      else
        @params[key_name]
      end
    end

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