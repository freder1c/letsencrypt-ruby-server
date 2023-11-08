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

      # TODO: consider preferred challange type
      def place(order, key)
        client = acme_client(key)
        new_acme_account(client)
        client_order = client.new_order(identifiers: [order.identifier])
        enrich_order(order, client_order.to_h)
        authorization = client_order.authorizations.first

        raise Error::ServiceUnavailable unless authorization

        authorization
      end

      # TODO: Use different key for account and csr, as same is not allowed
      def finalize(order, key)
        client = acme_client(key)
        csr = Acme::Client::CertificateRequest.new(private_key: key.file, subject: { common_name: order.identifier })
        order_request = acme_order(client, order)
        order_request.finalize(csr:)
        order.status = order_request.status
        table.filter(id: order.id).update(order.changed) if order.changed?
        order.persisted!
      end

      def resolve(order, key)
        client = acme_client(key)
        order_request = acme_order(client, order)
        order_request.reload # fetch current status
        order.status = order_request.status
        table.filter(id: order.id).update(order.changed) if order.changed?
        order.persisted!
      end

      private

      def table
        DB[:orders]
      end

      def acme_client(key)
        Acme::Client.new(private_key: key.file, directory: Application.acme_directory)
      end

      def new_acme_account(client)
        client.new_account(contact: "mailto:#{account.email}", terms_of_service_agreed: true) unless client.kid
        client
      end

      def enrich_order(order, hash)
        order.url = hash[:url]
        order.status = hash[:status]
        order.certificate_url = hash[:certificate_url]
        order.expires_at = Time.parse(hash[:expires]).utc
        order.finalize_url = hash[:finalize_url]
      end

      def acme_order(acme_client, order)
        Acme::Client::Resources::Order.new(acme_client,
                                           url: order.url,
                                           status: order.status,
                                           expires: nil,
                                           finalize_url: order.finalize_url,
                                           authorization_urls: nil,
                                           identifiers: nil,
                                           certificate_url: nil)
      end
    end
  end
end
