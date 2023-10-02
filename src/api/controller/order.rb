# frozen_string_literal: true

module Application
  module Controller
    class Order < Base
      def create
        authenticate!

        order = Command::Order::Create.new(account).call(request.payload)
        Response.new(status: 201, body: Presenter::Order.new(order).present!)
      end
    end
  end
end
