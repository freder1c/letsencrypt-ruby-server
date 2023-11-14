# frozen_string_literal: true

module Application
  module Command
    module Account
      class Create
        def call(params = {})
          params = Validator.validate(Validator::Account::Create, params)
          account = Data::Account.new(params)
          check_if_email_is_taken(account)

          Repository::Account.new(nil).create(account)
        end

        private

        def check_if_email_is_taken(account)
          existing = Repository::Account.new(nil).find_by_email(account.email)

          raise Error::UnprocessableEntity, email: [{ error: :taken }] if existing.present?
        end
      end
    end
  end
end
