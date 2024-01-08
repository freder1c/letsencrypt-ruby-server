# frozen_string_literal: true

module Application
  module Data
    class Base
      class << self
        attr_reader :attributes

        def attribute(key, default: nil)
          default = nil if default == ""
          @attributes ||= {}
          @attributes.merge!(key.to_sym => default)

          define_method(key) { instance_variable_get("@#{key}") }
          define_method("#{key}_was") { instance_variable_get("@#{key}_was") }
          define_method("#{key}=") { |value| instance_variable_set("@#{key}", value) }
        end
      end

      def initialize(params = {})
        self.class.attributes.each { |key, default| send("#{key}=", default) }
        params.each do |key, value|
          send("#{key}=", value)
          instance_variable_set("@#{key}_was", value)
        end
      end

      def attributes(keys = self.class.attributes.keys)
        keys.to_h { |key, _| [key.to_sym, instance_variable_get("@#{key}")] }
      end

      def attributes_without_nils(keys = self.class.attributes.keys)
        keys.to_h { |key, _| [key.to_sym, instance_variable_get("@#{key}")] }.compact
      end

      def attributes=(params = {})
        params.each { |key, value| send("#{key}=", value) }
      end

      def changed
        attributes(
          self.class.attributes.reject do |key, _|
            instance_variable_get("@#{key}") == instance_variable_get("@#{key}_was")
          end.keys
        )
      end

      def changed?
        !changed.empty?
      end

      def persisted!(attrs = [])
        to_persist = attrs.size.positive? ? attrs : self.class.attributes

        to_persist.each_key do |key|
          current = instance_variable_get("@#{key}")
          instance_variable_set("@#{key}_was", current) if current != instance_variable_get("@#{key}_was")
        end

        self
      end
    end
  end
end
