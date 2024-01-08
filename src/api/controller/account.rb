# frozen_string_literal: true

module Application
  module Controller
    class Account < Base
      def fetch
        authenticate!

        Response.new(status: 200, body: Presenter::Account.new(account).present!)
      end

      def create
        account = Command::Account::Create.new.call(request.payload)
        Response.new(status: 201, body: Presenter::Account.new(account).present!)
      end

      def update_key
        authenticate!

        Command::Account::UpdateKey.new(account).call(request.payload)
        Response.new(status: 204, body: nil)
      end

      def update_locale
        authenticate!

        Command::Account::UpdateLocale.new(account).call(request.payload)
        Response.new(status: 204, body: nil)
      end
    end
  end
end
