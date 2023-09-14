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

          if account.valid_password?(params[:password])
            reset_failed_attempts(account)
          else
            increase_failed_attempts(account)
          end

          Repository::Session.new.create(Data::Session.new(account:))
        end

        private

        def account_repo
          @account_repo ||= Repository::Account.new
        end

        def reset_failed_attempts(account)
          return if account.failed_attempts.zero?

          account.failed_attempts = 0
          account_repo.update(account)
        end

        def increase_failed_attempts(account)
          account.failed_attempts += 1
          account.locked_at = Time.current if account.failed_attempts > 10
          account_repo.update(account)

          raise Error::PasswordInvalid
        end
      end
    end
  end
end
