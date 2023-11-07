# frozen_string_literal: true

module Application
  module Command
    module Challenge
      class Validate < Base
        def call(id, options = {})
          order = Order::Find.new(account).call(options[:order_id])
          challenge = Repository::Challenge.new(account).find(id, options)
          challenge_found?(challenge)

          key = Key::Find.new(account).call(order.key_id, with_file: true)
          Repository::Challenge.new(account).validate(challenge, key)
        end

        private

        def challenge_found?(challenge)
          raise Error::NotFound.new("challenge", id) if challenge.nil?
        end
      end
    end
  end
end
