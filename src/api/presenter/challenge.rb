# frozen_string_literal: true

module Application
  module Presenter
    class Challenge < Base
      def record(challenge)
        {
          id: challenge.id,
          order_id: challenge.order_id,
          url: challenge.url,
          token: challenge.token,
          status: challenge.status,
          type: challenge.type,
          content: challenge.content,
          created_at: challenge.created_at.iso8601
        }
      end
    end
  end
end
