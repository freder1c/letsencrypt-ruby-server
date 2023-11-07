# frozen_string_literal: true

module Application
  module Repository
    class Order < Base
      def find(id)
        sql = table.where(id:, account_id:)
        wrap_data(sql.first, data: Data::Order, request: sql)
      end

      def create(order)
        order.created_at = Time.current
        order.id = table.insert(order.attributes_without_nils.except(:challenge_content))
        order.persisted!
      end

      def place(order, key)
        client_instance = client(key)
        # TODO: consider preferred challange type
        client_order = client_instance.new_order(identifiers: [order.identifier])
        authorization = client_order.authorizations.first

        raise Error::ServiceUnavailable unless authorization

        authorization
      end

      private

      def table
        DB[:orders]
      end

      def client(key)
        client = Acme::Client.new(private_key: key.file, directory: Application.acme_directory)
        client.new_account(contact: "mailto:#{account.email}", terms_of_service_agreed: true) unless client.kid
        client
      end
    end
  end
end
