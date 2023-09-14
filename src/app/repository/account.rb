# frozen_string_literal: true

module Application
  module Repository
    class Account < Base
      def find_by_email(email)
        sql = table.where(email:)
        wrap_data(sql.first, data: Data::Account, request: sql)
      end

      private

      def table
        DB[:accounts]
      end
    end
  end
end
