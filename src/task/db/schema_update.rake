# frozen_string_literal: true

namespace :db do
  namespace :schema do
    desc "Database schema update"
    task :update, [:version] => :environment do |_t, args|
      version = args[:version].nil? ? nil : Integer(args[:version])
      Sequel.extension :migration

      if version
        Sequel::Migrator.run(Application::DB, File.join("db", "updates"), target: version)
      else
        Sequel::Migrator.run(Application::DB, File.join("db", "updates"), allow_missing_migration_files: true)
      end

      Rake::Task["db:schema:dump"].invoke
      Application::Logger.info("Schema updated.")
    end
  end
end
