# frozen_string_literal: true

module Application
  module Controller
    class Order < Base
      def create
        authenticate!

        order = Command::Order::Create.new(account).call(request.payload)
        Response.new(status: 201, body: Presenter::Order.new(order).present!)
      end

      def find
        authenticate!

        challenge = Command::Challenge::Find.new(account).call(request.params[:id], order_id: request.params[:order_id])
        Response.new(status: 200, body: Presenter::Challenge.new(challenge).present!)
      end

      def finalize
        authenticate!

        Command::Order::Finalize.new(account).call(request.params[:id])
        Response.new(status: 202, body: nil)
      end
    end
  end
end
