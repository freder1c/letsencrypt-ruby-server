# frozen_string_literal: true

module Application
  module Repository
    class Challenge < Base
      def all(options = {})
        page = Data::Page.from_params(options)

        sql = table
        sql = filter(sql, options)

        wrap_collection(sql.all, data:, page:)
      end

      def find(id, options = {})
        sql = table.where(id:)
        sql = filter(sql, options)
        wrap_data(sql.first, data:, request: sql)
      end

      def create(challenge)
        challenge.created_at = Time.current
        challenge.id = table.insert(Helper::Sequel.sanitize(challenge.attributes_without_nils))
        challenge.persisted!
      end

      def validate(challenge, key)
        validate_dns(challenge, key) if challenge.type == "dns"
      rescue Acme::Client::Error::NotFound
        table.where(id: challenge.id).update(status: "not_found")
      end

      private

      def table
        DB[:challenges]
      end

      def data
        Data::Challenge
      end

      def filter(sql, options)
        sql = sql.where(order_id: options[:order_id]) if options[:order_id]
        sql
      end

      def validate_dns(challenge, key)
        client = Acme::Client.new(private_key: key.file, directory: Application.acme_directory)
        dns_challenge = Acme::Client::Resources::Challenges::DNS01.new(client,
                                                                       status: challenge.status,
                                                                       url: challenge.url,
                                                                       token: challenge.token)

        # TODO: Add background process to validate challenge state and update DB entry
        # Get status with => dns_challenge.status
        # Poll status with => dns_challenge.reload
        #
        # If sucessful status will change to "valid"

        dns_challenge.request_validation
      end
    end
  end
end
