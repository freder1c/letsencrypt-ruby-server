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

          challenges = place_order(order)
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
          key = Key::Find.new(account).call(id)
          check_if_key_is_account_key(key)
        rescue Error::NotFound
          raise Error::UnprocessableEntity, key_id: [{ error: :invalid, value: id }]
        end

        def check_if_key_is_account_key(key)
          return key if key.id != account.key_id

          raise Error::UnprocessableEntity, key_id: [{ error: :cant_be_same_as_account_key, value: key.id }]
        end

        def account_key
          @acount_key ||= Key::Find.new(account).call(account.key_id, with_file: true)
        rescue Error::NotFound
          raise Error::UnprocessableEntity, account: [{ error: :no_key_attached }]
        end

        def place_order(order)
          auth = order_repository.place(order, account_key)
          http_challenge = build_challenge(auth.http, "http")
          dns_challenge = build_challenge(auth.dns, "dns")
          challenges = [http_challenge, dns_challenge].compact

          raise Error::ServiceUnavailable if challenges.empty?

          challenges
        end

        def build_challenge(auth, type)
          return nil unless auth

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
