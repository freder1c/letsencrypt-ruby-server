# frozen_string_literal: true

module Application
  module Controller
    class Session < Base
      def create
        Response.new(status: 201, body: { token: SecureRandom.uuid })
      end

      def delete
        Response.new(status: 204, body: nil)
      end
    end
  end
end
