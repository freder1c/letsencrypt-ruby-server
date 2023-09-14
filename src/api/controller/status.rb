# frozen_string_literal: true

module Application
  module Controller
    class Status < Base
      def self.call
        Response.new(status: 200, body: { status: :ok, running_since: Application.started_at })
      end
    end
  end
end
