# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: "Application::Data::Order" do
    to_create { |instance| FactoryBot::Storage.insert(:orders, instance) }

    identifier { "*.example.de" }
    status { "created" }
    created_at { Time.current }
  end
end
