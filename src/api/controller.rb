# frozen_string_literal: true

module Application
  module Controller
    class Base
      attr_reader :request, :account

      def initialize(request)
        @request = request
      end

      private

      def authenticate!
        session = Repository::Session.new(nil).find(request.token) if valid_token?
        raise Error::Unauthorized if session.nil?

        @account = Repository::Account.new(nil).find(session.account_id)
        !account.nil?
      end

      def valid_token?
        !Validator.uuid_format.match(request.token).nil?
      end
    end
  end
end
