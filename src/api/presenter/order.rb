# frozen_string_literal: true

module Application
  module Presenter
    class Order < Base
      def record(order)
        {
          id: order.id,
          status: order.status,
          created_at: order.created_at.iso8601
        }
      end
    end
  end
end
