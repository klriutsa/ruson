require 'json'
require 'active_support'
require 'active_support/core_ext'

module Ruson
  class Base
    class << self
      def field(attr, options = {})
        add_accessor attr.to_s, options
      end

      def add_accessor(name, options)
        instance_eval("attr_accessor :#{name}")
        @accessors ||= {}
        @accessors.merge!({ name.to_sym => options })
      end

      def accessors
        @accessors
      end
    end

    def initialize(json, options = {})
      params  = convert(json)
      params  = params[options[:root].to_s] unless options[:root].nil?
      @params = params

      self.class.accessors.each do |key, options|
        val = get_val(options[:name] || key, options)
        set_attribute(key, val)
      end
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

    def convert(json)
      (json.class == Hash ? json : JSON.parse(json)).with_indifferent_access
    end
  end
end
