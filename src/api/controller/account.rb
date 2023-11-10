# frozen_string_literal: true

module Application
  module Controller
    class Account < Base
      def create
        account = Command::Account::Create.new(nil).call(request.params)
        Response.new(status: 200, body: Presenter::Account.new(account).present!)
      end

      def update
        authenticate!

        Command::Account::Update.new(account).call(request.payload)
        Response.new(status: 200, body: Presenter::Account.new(account).present!)
      end
    end
  end
end
