# frozen_string_literal: true

namespace :db do
  namespace :schema do
    desc "Database schema update"
    task :rollback, [:step] => :environment do |_t, args|
      step = args[:step].nil? ? 1 : Integer(args[:step])

      target = Application::DB[:schema_migrations].reverse_order(:filename).offset(step).first
      version = Integer(target[:filename].match(/(\d)+/)[0]) if target

      Rake::Task["db:schema:update"].invoke(version)
    end
  end
end
