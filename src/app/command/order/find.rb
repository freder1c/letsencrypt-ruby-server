# frozen_string_literal: true

module Application
  module Command
    module Order
      class Find < Base
        def call(id)
          raise Error::NotFound.new("order", id) if (order = Repository::Order.new(account).find(id)).nil?

          order
        end
      end
    end
  end
end
