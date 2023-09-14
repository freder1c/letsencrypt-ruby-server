# frozen_string_literal: true

namespace :db do
  namespace :schema do
    desc "Database schema dump"
    task dump: :environment do
      output_path = File.join("db", "schema.sql")

      command = []
      command << ["PGPASSWORD=\"#{ENV.fetch("DB_PASSWORD", nil)}\""] if ENV.fetch("DB_PASSWORD", nil)
      command << ["pg_dump", "--schema-only"]
      command << ["-h", ENV.fetch("DB_HOST", nil)] if ENV.fetch("DB_HOST", nil)
      command << ["-U", ENV.fetch("DB_USER", nil)] if ENV.fetch("DB_USER", nil)
      command << [ENV.fetch("DB_NAME"), ">", output_path]

      Application::DB.extension :schema_dumper
      schema_dump = Application::DB.dump_schema_migration(same_db: true)
      File.write("/app/db/schema.rb", schema_dump)

      system(command.join(" "), exception: true)
      Application::Logger.info("Schema dumped to #{output_path}.")
    end
  end
end
