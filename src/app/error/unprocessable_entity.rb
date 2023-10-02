# frozen_string_literal: true

module Application
  module Error
    class UnprocessableEntity < StandardError
      attr_reader :details

      def initialize(details)
        @details = details
        super("Unprocessable entity.")
      end
    end
  end
end
