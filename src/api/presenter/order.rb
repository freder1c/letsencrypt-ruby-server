# frozen_string_literal: true

module Application
  module Presenter
    class Order < Base
      def record(order)
        {
          id: order.id,
          key_id: order.key_id,
          status: order.status,
          certificate_url: order.certificate_url,
          created_at: order.created_at.iso8601,
          expires_at: order.expires_at.iso8601
        }
      end
    end
  end
end
