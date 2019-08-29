require 'json'
require 'active_support'
require 'active_support/core_ext'

require 'ruson/class/boolean'
require 'ruson/class/integer'
require 'ruson/class/float'

require 'ruson/converter'
require 'ruson/json'
require 'ruson/value'

require 'ruson/error'

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

    include Ruson::Converter
    include Ruson::Json
    include Ruson::Value

    def initialize(json, root_key: nil)
      params = get_hash_from_json(json)
      params = params[root_key.to_s] unless root_key.nil?

      init_attributes(self.class.accessors, params)
    end

    def to_hash
      convert_to_hash(self.class.accessors)
    end

    def to_json
      to_hash.to_json
    end

    private

    def init_attributes(accessors, params)
      accessors.each do |key, options|
        val = get_val(params, options[:name] || key, options)
        set_attribute(key, val)
      end
    end

    def set_attribute(attr_name, val)
      self.send("#{attr_name}=".to_sym, val)
    end
  end
end
