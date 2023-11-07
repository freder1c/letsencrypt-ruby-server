# frozen_string_literal: true

require "sequel"

module Application
  module Helper
    module Sequel
      module_function

      def sanitize(attributes)
        sanitized = {}

        attributes.each do |k, v|
          if v.is_a?(Hash) || v.is_a?(Array)
            v = sanitize_array(v) if v.is_a?(Array)
            sanitized[k] = ::Sequel.pg_jsonb(v)
          else
            sanitized[k] = v
          end
        end

        sanitized
      end

      def sanitize_array(array)
        array.map do |elem|
          elem.is_a?(Application::Data::Base) ? elem.attributes_without_nils : elem
        end
      end
    end
  end
end
