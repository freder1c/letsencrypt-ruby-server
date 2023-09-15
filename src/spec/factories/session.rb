# frozen_string_literal: true

FactoryBot.define do
  factory :session, class: "Application::Data::Session" do
    to_create { |instance| FactoryBot::Storage.insert(:sessions, instance) }

    created_at { Time.current }
  end
end
