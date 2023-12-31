# frozen_string_literal: true

module Application
  module Command
    module Challenge
      class All < Base
        def call(options = {})
          Order::Find.new(account).call(options[:order_id])
          Repository::Challenge.new(account).all(options)
        end
      end
    end
  end
end
