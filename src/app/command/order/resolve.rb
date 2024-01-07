# frozen_string_literal: true

module Application
  module Command
    module Order
      class Resolve < Base
        def call(id)
          order = Find.new(account).call(id)
          account_key = Key::Find.new(account).call(account.key_id, with_file: true)
          Repository::Order.new(account).resolve(order, account_key)
        end
      end
    end
  end
end
