# frozen_string_literal: true

module Application
  module Error
    class ServiceUnavailable < StandardError
      def initialize
        super("Service unavailable.")
      end
    end
  end
end
