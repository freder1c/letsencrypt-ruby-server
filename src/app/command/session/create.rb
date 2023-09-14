# frozen_string_literal: true

module Application
  module Command
    module Session
      class Create
        def call(params = {})
          params = Validator.validate(Validator::Session::Create, params)
          account = account_repo.find_by_email(params[:email])

          raise Error::EmailNotFound if account.nil?
          raise Error::AccountLocked if account.locked?

          Data::Session.new(id: SecureRandom.uuid)
        end

        private

        def account_repo
          @account_repo ||= Repository::Account.new
        end
      end
    end
  end
end
