# frozen_string_literal: true

module Application
  module Data
    class Key < Base
      attribute :id
      attribute :account_id
      attribute :file
      attribute :created_at

      def account=(account)
        raise Error::WrongAssignement unless account.is_a?(Data::Account)

        self.account_id = account.id
      end
    end
  end
end
