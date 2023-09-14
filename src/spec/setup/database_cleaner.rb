# frozen_string_literal: true

require "database_cleaner/sequel"

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:sequel].db = Application::DB
    DatabaseCleaner[:sequel].strategy = :truncation
    DatabaseCleaner.strategy = :deletion
  end

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
