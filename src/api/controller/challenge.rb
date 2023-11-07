# frozen_string_literal: true

module Application
  module Controller
    class Challenge < Base
      def all
        authenticate!

        challenges = Command::Challenge::All.new(account).call(order_id: request.params[:order_id])
        Response.new(status: 200, body: Presenter::Challenge.new(challenges).present!, page: challenges.page)
      end

      def find
        authenticate!

        challenge = Command::Challenge::Find.new(account).call(request.params[:id], order_id: request.params[:order_id])
        Response.new(status: 200, body: Presenter::Challenge.new(challenge).present!)
      end
    end
  end
end
