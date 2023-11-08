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

          challenges = place_order(order, key)
          permit_state(order, challenges)

          order
        end

        private

        def order_repository
          @order_repository ||= Repository::Order.new(account)
        end

        def challenge_repository
          @challenge_repository ||= Repository::Challenge.new(account)
        end

        def find_key(id)
          Key::Find.new(account).call(id, with_file: true)
        rescue Error::NotFound
          raise Error::UnprocessableEntity, id: [{ error: :invalid, value: id }]
        end

        def place_order(order, key)
          auth = order_repository.place(order, key)
          http_challenge = build_challenge(auth.http, "http") if auth.http
          dns_challenge = build_challenge(auth.dns, "dns") if auth.dns
          challenges = [http_challenge, dns_challenge].compact

          raise Error::ServiceUnavailable if challenges.empty?

          challenges
        end

        def build_challenge(auth, type)
          Data::Challenge.new(
            url: auth.url, status: auth.status, token: auth.token, type:, content: build_content(auth, type)
          )
        end

        def build_content(auth, type)
          case type
          when "http" then http_content(auth)
          when "dns" then dns_content(auth)
          else raise Error::ChallengeTypeNotSupported, type:
          end
        end

        def http_content(auth)
          { file_content: auth.file_content, filename: auth.filename, token: auth.token }
        end

        def dns_content(auth)
          { record_name: auth.record_name, record_type: auth.record_type, record_content: auth.record_content }
        end

        def permit_state(order, challenges)
          order_repository.create(order)

          challenges.each do |challenge|
            challenge.order = order
            challenge_repository.create(challenge)
          end
        end
      end
    end
  end
end
