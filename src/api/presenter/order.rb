# frozen_string_literal: true

module Application
  module Presenter
    class Order < Base
      def record(order)
        {
          id: order.id,
          key_id: order.key_id,
          status: order.status,
          challenge_type: order.challenge_type,
          challenge_content: order.challenge_content,
          created_at: order.created_at.iso8601
        }
      end
    end
  end
end
