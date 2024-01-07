# frozen_string_literal: true

module Application
  module Command
    module Challenge
      class Find < Base
        def call(id, options = {})
          Order::Find.new(account).call(options[:order_id])
          challenge = Repository::Challenge.new(account).find(id, { order_id: options[:order_id] })

          raise Error::NotFound.new("challenge", id) if challenge.nil?

          challenge
        end
      end
    end
  end
end
