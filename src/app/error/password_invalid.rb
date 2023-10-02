# frozen_string_literal: true

module Application
  module Error
    class PasswordInvalid < StandardError
      def initialize
        super("Password invalid.")
      end
    end
  end
end
