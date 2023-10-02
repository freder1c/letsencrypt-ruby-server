# frozen_string_literal: true

module Application
  module Error
    class WrongAssignement < StandardError
      def initialize
        super("Wrong assignment.")
      end
    end
  end
end
