# frozen_string_literal: true

module Application
  module Controller
    class Key < Base
      def all
        authenticate!

        keys = Command::Key::All.new(account).call(request.params)
        Response.new(status: 200, body: Presenter::Key.new(keys).present!, page: keys.page)
      end

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

      def download
        authenticate!

        key = Command::Key::Find.new(account).call(request.params[:id], with_file: true)
        Response.new(status: 200, body: key.file.to_s, type: "application/x-pem-file")
      end
    end
  end
end
