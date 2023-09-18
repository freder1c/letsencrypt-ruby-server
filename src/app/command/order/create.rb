# frozen_string_literal: true

module Application
  module Command
    module Order
      class Create < Base
        def call
          order = Data::Order.new(account:)
          Repository::Order.new(account).create(order)
        end
      end
    end
  end
end
