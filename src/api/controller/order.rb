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

        order = Command::Order::Find.new(account).call(request.params[:id], order_id: request.params[:order_id])
        Response.new(status: 200, body: Presenter::Order.new(order).present!)
      end

      def finalize
        authenticate!

        order = Command::Order::Finalize.new(account).call(request.params[:id])
        Response.new(status: 202, body: Presenter::Order.new(order).present!)
      end

      def resolve
        authenticate!

        order = Command::Order::Resolve.new(account).call(request.params[:id])
        Response.new(status: 200, body: Presenter::Order.new(order).present!)
      end
    end
  end
end
