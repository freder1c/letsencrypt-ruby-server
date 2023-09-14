# frozen_string_literal: true

module Application
  module Error
    class UnprocessableEntity < StandardError
      attr_reader :details

      def initialize(details)
        super
        @details = details
      end
    end
  end
end
