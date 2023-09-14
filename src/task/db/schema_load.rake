# frozen_string_literal: true

namespace :db do
  namespace :schema do
    desc "Database schema load"
    task load: :environment do
      input_path = File.join("db", "schema.sql")

      command = []
      command << ["PGPASSWORD=\"#{ENV.fetch("DB_PASSWORD", nil)}\""] if ENV.fetch("DB_PASSWORD", nil)
      command << ["psql"]
      command << ["-h", ENV.fetch("DB_HOST", nil)] if ENV.fetch("DB_HOST", nil)
      command << [ENV.fetch("DB_NAME"), "<", input_path]
      command << [">", "/dev/null"]

      system(command.join(" "), exception: true)

      Dir.glob(File.join("db", "updates", "*.rb")) do |schema_update_file|
        Application::DB[:schema_migrations].insert(filename: schema_update_file.split("/").last)
      end

      Application::Logger.info("Schema loaded from #{input_path}.")
    end
  end
end
