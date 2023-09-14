# frozen_string_literal: true

module Application
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      Thread.current[:process_id] = SecureRandom.uuid
      starttime = Time.current
      status, headers, body = @app.call(env)
      log(env, Thread.current[:status] = status, Thread.current[:duration] = (Time.current - starttime))
      [status, headers, body]
    end

    private

    def log(env, status, duration)
      Logger.info(
        "#{env["REQUEST_METHOD"]} #{env["REQUEST_URI"]} #{status} #{duration} " \
        "from #{env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"] || "-"}"
      )
    end
  end
end
