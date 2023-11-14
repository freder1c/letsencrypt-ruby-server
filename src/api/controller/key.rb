# frozen_string_literal: true

module Application
  module Controller
    class Key < Base
      def generate
        authenticate!

        key = Command::Key::Generate.new(account).call(request.payload)
        Response.new(status: 201, body: Presenter::Key.new(key).present!)
      end

      def upload
        authenticate!

        key = Command::Key::Upload.new(account).call(request.body)
        Response.new(status: 201, body: Presenter::Key.new(key).present!)
      end
    end
  end
end
