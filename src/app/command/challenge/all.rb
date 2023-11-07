# frozen_string_literal: true

module Application
  module Command
    module Challenge
      class All < Base
        def call(options = {})
          order = Order::Find.new(account).call(options[:order_id]) if options[:order_id]
          Repository::Challenge.new(account).all(options.merge(order_id: order.id))
        end
      end
    end
  end
end
