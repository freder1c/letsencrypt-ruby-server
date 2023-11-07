# frozen_string_literal: true

module Application
  module Command
    module Order
      class Create < Base
        def call(params = {})
          params = Validator.validate(Validator::Order::Create, params)
          key = find_key(params[:key_id])
          order = Data::Order.new(account:, key:)
          order.identifier = params[:identifier]

          challenge = place_order(order, key)
          permit_state(order, challenge)

          order
        end

        private

        def order_repository
          @order_repository ||= Repository::Order.new(account)
        end

        def find_key(id)
          Key::Find.new(account).call(id, with_file: true)
        rescue Error::NotFound
          raise Error::UnprocessableEntity, id: [{ error: :invalid, value: id }]
        end

        def place_order(order, key)
          authorization = order_repository.place(order, key)

          challenge = set_http_challenge(authorization.http, order) if authorization.http
          challenge = set_dns_challenge(authorization.dns, order) if authorization.dns

          raise Error::ServiceUnavailable unless challenge

          challenge
        end

        def set_http_challenge(http, _order)
          Data::Challenge.new(
            url: http.url,
            status: http.status,
            token: http.token,
            type: "http",
            content: render_http_content(http)
          )
        end

        def set_dns_challenge(dns, _order)
          Data::Challenge.new(
            url: dns.url,
            status: dns.status,
            token: dns.token,
            type: "dns",
            content: render_dns_content(dns)
          )
        end

        def render_http_content(http)
          { file_content: http.file_content, filename: http.filename, token: http.token }
        end

        def render_dns_content(dns)
          { record_name: dns.record_name, record_type: dns.record_type, record_content: dns.record_content }
        end

        def permit_state(order, challenge)
          challenge.order = order_repository.create(order)
          Repository::Challenge.new(account).create(challenge)
        end
      end
    end
  end
end
