# frozen_string_literal: true

module Application
  module Data
    class Order < Base
      attribute :id
      attribute :account_id
      attribute :key_id
      attribute :identifier
      attribute :challenge_type
      attribute :challenge_content
      attribute :status, default: "created"
      attribute :created_at

      def account=(account)
        raise Error::WrongAssignement unless account.is_a?(Data::Account)

        self.account_id = account.id
      end

      def key=(key)
        raise Error::WrongAssignement unless key.is_a?(Data::Key)

        self.key_id = key.id
      end
    end
  end
end
