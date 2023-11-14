# frozen_string_literal: true

FactoryBot.define do
  factory :account, class: "Application::Data::Account" do
    to_create { |instance| FactoryBot::Storage.insert(:accounts, instance) }

    email { "test@example.com" }
    password { "1!Secret" }
    locale { "en-US" }
    created_at { Time.current }
  end
end
