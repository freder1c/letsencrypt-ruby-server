# frozen_string_literal: true

module Application
  module Presenter
    class Account < Base
      def record(account)
        {
          email: account.email,
          locale: account.locale,
          key_id: account.key_id
        }
      end
    end
  end
end
