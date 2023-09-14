# frozen_string_literal: true

namespace :db do
  namespace :schema do
    desc "Database schema template for update"
    task :template, [:name] => :environment do |_t, args|
      unless (name = args[:name])
        Application::Logger.warn("No name specified. Example usage: `rake db:generate:schema_update[my_update]`")
        exit
      end

      version = Time.now.utc.strftime("%Y%m%d%H%M%S")
      dir = File.join("db", "updates")
      path = File.join(dir, "#{version}_#{name}.rb")

      Dir.entries(dir).each do |file|
        next unless file.sub(/([0-9]+_)/, "") == "#{name}.rb"

        Application::Logger.warn("Schema update file with name #{name} already exists.")
        exit
      end

      File.write path, <<~CONTENT
        # frozen_string_literal: true

        Sequel.migration do
          change do
          end
        end
      CONTENT

      Application::Logger.info("Schema update file generated.")
    end
  end
end
