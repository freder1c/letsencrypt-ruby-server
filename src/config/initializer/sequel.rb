# frozen_string_literal: true

require "sequel"

def db_config
  {
    adapter: :postgres,
    user: ENV.fetch("DB_USER", nil),
    password: ENV.fetch("DB_PASSWORD", nil),
    host: ENV.fetch("DB_HOST", nil),
    post: ENV.fetch("DB_PORT", 5432),
    database: ENV.fetch("DB_NAME"),
    logger: Application::Logger
  }
end

def establish!
  retries ||= 5

  Sequel.connect(db_config).tap(&:test_connection)
rescue Sequel::DatabaseConnectionError => e
  raise e if (retries -= 1).negative?

  Application::Logger.warn("Retry to establish database connection.")
  sleep 5

  retry
end

module Application
  DB = establish!
  # DB.extension(:pg_json)
  DB.sql_log_level = :debug
end
