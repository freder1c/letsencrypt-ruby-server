# frozen_string_literal: true

module Application
  module Command
    module Account
      class UpdateLocale < Base
        def call(params = {})
          params = Validator.validate(Validator::Account::UpdateLocale, params)
          account.attributes = params
          Repository::Account.new.update(account)
        end
      end
    end
  end
end
