# frozen_string_literal: true

module Application
  module Command
    module Order
      class Create < Base
        def call(params = {})
          params = Validator.validate(Validator::Order::Create, params)
          key = find_key(params[:key_id])
          order = Data::Order.new(account:, key:)
          order.attributes = params.except(:key_id)

          client = init_client(key)
          challenge = place_order(client, order)

          permit_state(order, challenge)
          order
        end

        private

        def find_key(id)
          Key::Find.new(account).call(id, with_file: true)
        rescue Error::NotFound
          raise Error::UnprocessableEntity, id: [{ error: :invalid, value: id }]
        end

        def init_client(key)
          client = Acme::Client.new(private_key: key.file, directory: Application.acme_directory)
          client.new_account(contact: "mailto:#{account.email}", terms_of_service_agreed: true) unless client.kid
          client
        end

        def place_order(client, order)
          client_order = client.new_order(identifiers: [order.identifier])
          authorization = client_order.authorizations.first
          raise Error::ServiceUnavailable unless authorization

          challenge = set_http_challenge(authorization.http, order) if authorization.http
          challenge = set_dns_challenge(authorization.dns, order) if authorization.dns

          raise Error::ServiceUnavailable unless challenge

          challenge
        end

        def set_http_challenge(http, order)
          order.challenge_type = "http"
          order.challenge_content = render_http_content(http)
          Data::Challenge.new(url: http.url, status: http.status, token: http.token)
        end

        def set_dns_challenge(dns, order)
          order.challenge_type = "dns"
          order.challenge_content = render_dns_content(dns)
          Data::Challenge.new(url: dns.url, status: dns.status, token: dns.token)
        end

        def render_http_content(http)
          { content_type: http.content_type, file_content: http.file_content, filename: http.filename,
            token: http.token }
        end

        def render_dns_content(dns)
          { record_name: dns.record_name, record_type: dns.record_type, record_content: dns.record_content }
        end

        def permit_state(order, challenge)
          challenge.order = Repository::Order.new(account).create(order)
          Repository::Challenge.new(account).create(challenge)
        end
      end
    end
  end
end
