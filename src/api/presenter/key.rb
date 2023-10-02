# frozen_string_literal: true

module Application
  module Presenter
    class Key < Base
      def record(key)
        {
          id: key.id,
          created_at: key.created_at.iso8601
        }
      end
    end
  end
end
