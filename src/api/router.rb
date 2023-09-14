# frozen_string_literal: true

require "json"
require "roda"

module Application
  class Router < Roda
    def parse(request, params: {})
      Request.new(
        token: request.get_header("HTTP_AUTHENTICATION"),
        body: request.body.read,
        params: request.params.merge(params).symbolize_keys
      )
    end

    def render(resp)
      response.headers["Content-Type"] = resp.type
      response.headers["X-Request"] = Thread.current[:process_id]
      response.status = resp.status
      resp.body
    end

    route do |request|
      request.on("status") do
        request.is(method: :get) { render(Controller::Status.call) }
      end

      request.on("session") do
        request.is(method: :post) { render(Controller::Session.new(parse(request)).create) }
        request.is(method: :delete) { render(Controller::Session.new(parse(request)).delete) }
      end
    rescue Error::UnprocessableEntity => exception
      Logger.warn(exception.details)
      render Response.new(status: 422, body: { error: "Unprocessable Entity", details: exception.details })
    rescue StandardError => exception
      Logger.error("#{exception.message}\n\n\nBacktrace:\n" + exception.backtrace.join("\n"))
      render Response.new(status: 500, body: { error: "Internal Server Error" })
    end
  end
end
