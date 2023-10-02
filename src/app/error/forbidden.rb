# frozen_string_literal: true

module Application
  module Error
    class Forbidden < StandardError
      def initialize
        super("Forbidden.")
      end
    end
  end
end
