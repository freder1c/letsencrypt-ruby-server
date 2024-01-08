# frozen_string_literal: true

module Application
  module Command
    module Order
      class Finalize < Base
        def call(id)
          order = Find.new(account).call(id)
          order_key = Key::Find.new(account).call(order.key_id, with_file: true)
          account_key = Key::Find.new(account).call(account.key_id, with_file: true)
          Repository::Order.new(account).finalize(order, order_key, account_key)
        end
      end
    end
  end
end
