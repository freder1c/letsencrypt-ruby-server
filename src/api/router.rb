# frozen_string_literal: true

require "json"
require "roda"

module Application
  class Router < Roda
    def parse(request, params: {})
      body = is_multipart?(request) ? sanitize_params(request, params) : request.body.read
      params = is_multipart?(request) ? {} : sanitize_params(request, params)

      Request.new(token: request.get_header("HTTP_AUTHENTICATION"), body:, params:)
    end

    def is_multipart?(request)
      request.get_header("CONTENT_TYPE")&.match(/multipart\/form-data/) != nil
    end

    def sanitize_params(request, params)
      request.params.merge(params).symbolize_keys
    end

    def render(resp)
      response.headers["Content-Type"] = resp.type
      response.headers["X-Request"] = Thread.current[:process_id]
      add_page_headers(resp) if resp.page
      response.status = resp.status
      resp.body
    end

    def add_page_headers(resp)
      response.headers["Page-Number"] = resp.page.number
      response.headers["Page-Size"] = resp.page.size
    end

    route do |request|
      request.on("status") do
        request.is(method: :get) { render(Controller::Status.call) }
      end
      request.on("account") do
        request.is(method: :post) { render(Controller::Account.new(parse(request)).create) }
        request.on("email") do
          request.is(method: :put) { render(Controller::Account.new(parse(request)).update_email) }
        end
        request.on("key") do
          request.is(method: :put) { render(Controller::Account.new(parse(request)).update_key) }
        end
        request.on("locale") do
          request.is(method: :put) do
            render(Controller::Account.new(parse(request)).update_locale)
          end
        end
        request.on("password") do
          request.is(method: :put) { render(Controller::Account.new(parse(request)).update_password) }
        end
      end
      request.on("session") do
        request.is(method: :post) { render(Controller::Session.new(parse(request)).create) }
        request.is(method: :delete) { render(Controller::Session.new(parse(request)).delete) }
      end
      request.on("keys") do
        request.on("generate") do
          request.is(method: :post) { render(Controller::Key.new(parse(request)).generate) }
        end
        request.on("upload") do
          request.is(method: :post) { render(Controller::Key.new(parse(request)).upload) }
        end
      end
      request.on("orders") do
        request.is(method: :post) { render(Controller::Order.new(parse(request)).create) }
        request.on(String) do |id|
          request.on("challenges") do
            request.is(method: :get) { render(Controller::Challenge.new(parse(request, params: { order_id: id })).all) }
            request.on(String) do |challenge_id|
              request.is(method: :get) do
                render(Controller::Challenge.new(parse(request, params: { id: challenge_id, order_id: id })).find)
              end
              request.on("validate") do
                request.is(method: :post) do
                  render(Controller::Challenge.new(parse(request, params: { id: challenge_id, order_id: id })).validate)
                end
              end
              request.on("resolve") do
                request.is(method: :post) do
                  render(Controller::Challenge.new(parse(request, params: { id: challenge_id, order_id: id })).resolve)
                end
              end
            end
          end
          request.on("finalize") do
            request.is(method: :post) do
              render(Controller::Order.new(parse(request, params: { id: })).finalize)
            end
          end
          request.on("resolve") do
            request.is(method: :post) do
              render(Controller::Order.new(parse(request, params: { id: })).resolve)
            end
          end
        end
      end
    rescue Error::Unauthorized
      render Response.new(status: 401, body: { error: "Unauthorized" })
    rescue Error::Forbidden
      render Response.new(status: 403, body: { error: "Forbidden" })
    rescue Error::NotFound => exception
      render Response.new(status: 404, body: { error: "Not Found", details: exception.details })
    rescue Error::UnprocessableEntity => exception
      Logger.warn(exception.details)
      render Response.new(status: 422, body: { error: "Unprocessable Entity", details: exception.details })
    rescue Error::ServiceUnavailable
      render Response.new(status: 503, body: { error: "Service Unavailable" })
    rescue StandardError => exception
      Logger.error("#{exception.message}\n\n\nBacktrace:\n" + exception.backtrace.join("\n"))
      render Response.new(status: 500, body: { error: "Internal Server Error" })
    end
  end
end
