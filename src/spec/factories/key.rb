# frozen_string_literal: true

FactoryBot.define do
  factory :key, class: "Application::Data::Key" do
    to_create { |instance| FactoryBot::Storage.insert(:keys, instance) }

    id { SecureRandom.hex(12) }
    created_at { Time.current }
  end
end
