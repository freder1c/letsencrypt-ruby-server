# frozen_string_literal: true

module Application
  module Repository
    class Account < Base
      def find_by_email(email)
        sql = table.where(email:)
        wrap_data(sql.first, data: Data::Account, request: sql)
      end

      def update(account)
        table.filter(id: account.id).update(account.changed) if account.changed?
        account
      end

      private

      def table
        DB[:accounts]
      end
    end
  end
end
