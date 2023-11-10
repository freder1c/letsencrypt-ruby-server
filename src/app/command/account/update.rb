# frozen_string_literal: true

module Application
  module Command
    module Account
      class Update < Base
        def call(params = {})
          params = Validator.validate(Validator::Account::Update, params)
          account.attributes = params
          Repository::Account.new(account).update
        end
      end
    end
  end
end
