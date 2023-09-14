# frozen_string_literal: true

module Application
  module Data
    class NullRecord < Base
      attribute :request

      def nil?
        true
      end

      def present?
        false
      end
    end
  end
end
