# frozen_string_literal: true

module Application
  module Command
    module Challenge
      class Find < Base
        def call(id, options = {})
          order = Order::Find.new(account).call(options[:order_id]) if options[:order_id]
          challenge = Repository::Challenge.new(account).find(id, { order_id: order.id })

          raise Error::NotFound.new("challenge", id) if challenge.nil?

          challenge
        end
      end
    end
  end
end
