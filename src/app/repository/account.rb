# frozen_string_literal: true

module Application
  module Repository
    class Account < Base
      def find(id)
        query = table.where(id:)
        wrap_data(query.first, data:, request: query)
      end

      def find_by_email(email)
        query = table.where(email:)
        wrap_data(query.first, data:, request: query)
      end

      def update(account)
        table.filter(id: account.id).update(account.changed) if account.changed?
        account.persisted!
      end

      private

      def table
        DB[:accounts]
      end

      def data
        Data::Account
      end
    end
  end
end
