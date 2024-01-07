# frozen_string_literal: true

module Application
  module Command
    module Key
      class All < Base
        def call(options = {})
          options[:account_id] = account.id
          Repository::Key.new(account).all(options)
        end
      end
    end
  end
end
