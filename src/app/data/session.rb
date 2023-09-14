# frozen_string_literal: true

module Application
  module Data
    class Session < Base
      attribute :id
      attribute :account_id
      attribute :created_at
      attribute :expires_at, default: Time.current + 60.minutes

      def account=(account)
        raise Error::WrongAssignement unless account.is_a?(Data::Account)

        self.account_id = account.id
      end
    end
  end
end
