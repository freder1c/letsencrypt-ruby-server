# frozen_string_literal: true

module Application
  module Repository
    class Base
      attr_reader :account

      def initialize(account = nil)
        @account = account
      end

      def wrap_data(attributes, data:, request:)
        return Data::NullRecord.new(request:) if attributes.nil?

        data.new(attributes)
      end
    end
  end
end
