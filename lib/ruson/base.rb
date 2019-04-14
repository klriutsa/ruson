require 'json'
require 'active_support'
require 'active_support/core_ext'

module Ruson
  class Base
    class << self
      def field(attr, options = {})
        instance_eval("attr_accessor :#{attr.to_s}")
        add_accessor attr.to_s, options
      end

      def enum(attr, values)
        define_enum_methods attr.to_s, values.map(&:to_sym)
        add_accessor attr.to_s
      end

      def accessors
        @accessors
      end

      private

      def define_enum_methods(name, values)
        instance_eval("attr_reader :#{name}")

        define_method "#{name}=" do |v|
          raise ArgumentError, "#{v} is not a valid #{name}" unless values.include? v.to_sym
          eval "@#{name} = :#{v.to_s}"
        end

        values.each do |v|
          define_method "#{v}?" do
            eval "@#{name} == :#{v.to_s}"
          end
        end
      end

      def add_accessor(name, options = {})
        @accessors ||= {}
        @accessors.merge!({ name.to_sym => options })
      end
    end

    def initialize(json, root_key: nil)
      params = convert(json)
      params = params[root_key.to_s] unless root_key.nil?
      @params = params

      self.class.accessors.each do |key, options|
        val = get_val(options[:name] || key, options)
        set_attribute(key, val)
      end
    end

    def to_hash
      hash = Hash.new
      self.class.accessors.each do |accessor, options|
        value = send(accessor)
        if value.instance_of?(Array)
          array = []
          value.each do |v|
            if ruson_class?(v)
              array << v.to_hash
            else
              array << v
            end
          end
          hash[accessor.to_sym] = array
        else
          value = value.to_hash if ruson_class?(value)
          hash[accessor.to_sym] = value
        end
      end
      hash
    end

    def to_json
      to_hash.to_json
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
      return json if json.class == ActiveSupport::HashWithIndifferentAccess
      (json.class == Hash ? json : JSON.parse(json)).with_indifferent_access
    end

    def ruson_class?(value)
      value.class < Ruson::Base
    end
  end
end
