# frozen_string_literal: true

FactoryBot.define do
  factory :order, class: "Application::Data::Order" do
    to_create { |instance| FactoryBot::Storage.insert(:orders, instance) }

    identifier { "*.example.com" }
    url { "https://acme-staging-v02.api.letsencrypt.org/acme/order/120472004/12106331364" }
    finalize_url { "https://acme-staging-v02.api.letsencrypt.org/acme/finalize/120472004/12106331364" }
    status { "created" }
    created_at { Time.current }
    expires_at { Time.current + 34.days }
  end
end
