# frozen_string_literal: true

module Application
  module Repository
    class Account < Base
      def find(id)
        sql = table.where(id:)
        wrap_data(sql.first, data:, request: sql)
      end

      def find_by_email(email)
        sql = table.where(email:)
        wrap_data(sql.first, data:, request: sql)
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
