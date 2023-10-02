# frozen_string_literal: true

module Application
  module Error
    class AccountLocked < StandardError
      def initialize
        super("Account locked.")
      end
    end
  end
end
