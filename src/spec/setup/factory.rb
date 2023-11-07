# frozen_string_literal: true

require "factory_bot"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) { FactoryBot.find_definitions }
end

module FactoryBot
  module Storage
    module_function

    def insert(table, instance, except: [])
      attrs = Application::Helper::Sequel.sanitize(instance.attributes_without_nils.except(*except))
      instance.id = Application::DB[table].insert(attrs)
      instance
    end
  end
end
