# frozen_string_literal: true

module Application
  module Controller
    class Session < Base
      def create
        session = Command::Session::Create.new.call(request.payload)
        Response.new(status: 201, body: { token: session.id })
      rescue Error::EmailNotFound
        raise Error::Unauthorized
      rescue Error::AccountLocked
        raise Error::Forbidden
      end

      def delete
        Response.new(status: 204, body: nil)
      end
    end
  end
end
