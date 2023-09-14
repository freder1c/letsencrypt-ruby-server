# frozen_string_literal: true

module Application
  module Command
    class Base
      attr_reader :account

      def initialize(account)
        @account = account
      end
    end
  end
end
