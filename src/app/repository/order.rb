# frozen_string_literal: true

module Application
  module Repository
    class Order < Base
      def all(options = {})
        page = Data::Page.from_params(options)
        query = table.then { |sql| filter(sql, options) }
        wrap_collection(query.all, data:, page:)
      end

      def find(id)
        query = table.where(id:, account_id:)
        wrap_data(query.first, data:, request: query)
      end

      def find_for_key_id(key_id)
        query = table.where(key_id:, account_id:)
        wrap_data(query.first, data:, request: query)
      end

      def create(order)
        order.created_at = Time.current
        order.id = table.insert(order.attributes_without_nils.except(:challenge_content))
        order.persisted!
      end

      def place(order, key)
        client = acme_client(key)
        check_account(client)
        order_request = client.new_order(identifiers: [order.identifier])
        enrich_order(order, order_request.to_h)
        authorization = order_request.authorizations.first

        raise Error::ServiceUnavailable unless authorization

        authorization
      end

      def finalize(order, order_key, account_key)
        client = acme_client(account_key)
        csr = Acme::Client::CertificateRequest.new(private_key: order_key.file,
                                                   subject: { common_name: order.identifier })
        order_request = acme_order(client, order)
        order_request.finalize(csr:)
        enrich_order(order, order_request.to_h)
        table.filter(id: order.id).update(order.changed) if order.changed?
        order.persisted!
      end

      def resolve(order, account_key)
        client = acme_client(account_key)
        order_request = acme_order(client, order)
        order_request.reload # fetch current status
        enrich_order(order, order_request.to_h)
        table.filter(id: order.id).update(order.changed) if order.changed?
        order.persisted!
      end

      private

      def table
        DB[:orders]
      end

      def data
        Data::Order
      end

      def filter(query, options)
        query.then { |sql| options[:key_id] ? sql.where(key_id: options[:key_id]) : sql }
      end

      def acme_client(key)
        Acme::Client.new(private_key: key.file, directory: Application.acme_directory)
      end

      def check_account(client)
        client.kid
        client
      rescue Acme::Client::Error::AccountDoesNotExist
        client.new_account(contact: "mailto:#{account.email}", terms_of_service_agreed: true)
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
