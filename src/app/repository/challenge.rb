# frozen_string_literal: true

module Application
  module Repository
    class Challenge < Base
      def all(options = {})
        page = Data::Page.from_params(options)
        query = table.then { |sql| filter(sql, options) }
        wrap_collection(query.all, data:, page:)
      end

      def find(id, options = {})
        query = table.where(id:).then { |sql| filter(sql, options) }
        wrap_data(query.first, data:, request: query)
      end

      def create(challenge)
        challenge.created_at = Time.current
        challenge.id = table.insert(Helper::Sequel.sanitize(challenge.attributes_without_nils))
        challenge.persisted!
      end

      def validate(challenge, key)
        challenge_request = acme_challenge(challenge, key)
        challenge_request.request_validation
        challenge
      rescue Acme::Client::Error::NotFound
        table.where(id: challenge.id).update(status: "not_found")
      end

      def resolve(challenge, key)
        challenge_request = acme_challenge(challenge, key)
        challenge_request.reload # fetch current status
        challenge.status = challenge_request.status
        table.filter(id: challenge.id).update(challenge.changed) if challenge.changed?
        challenge.persisted!
      end

      private

      def table
        DB[:challenges]
      end

      def data
        Data::Challenge
      end

      def filter(query, options)
        query.then { |sql| options[:order_id] ? sql.where(order_id: options[:order_id]) : sql }
      end

      def acme_client(key)
        Acme::Client.new(private_key: key.file, directory: Application.acme_directory)
      end

      def acme_challenge(challenge, key)
        client = acme_client(key)

        return acme_dns_challenge(challenge, client) if challenge.type == "dns"
        return acme_http_challenge(challenge, client) if challenge.type == "http"

        raise Error::ChallengeTypeNotSupported, type: challenge.type
      end

      def acme_dns_challenge(challenge, client)
        Acme::Client::Resources::Challenges::DNS01.new(
          client, status: challenge.status, url: challenge.url, token: challenge.token
        )
      end

      def acme_http_challenge(challenge, client)
        Acme::Client::Resources::Challenges::HTTP01.new(
          client, status: challenge.status, url: challenge.url, token: challenge.token
        )
      end
    end
  end
end
