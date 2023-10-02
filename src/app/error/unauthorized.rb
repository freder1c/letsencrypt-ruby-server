# frozen_string_literal: true

module Application
  module Error
    class Unauthorized < StandardError
      def initialize
        super("Unauthorized.")
      end
    end
  end
end
