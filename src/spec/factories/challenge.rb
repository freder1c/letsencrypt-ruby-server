# frozen_string_literal: true

FactoryBot.define do
  factory :challenge, class: "Application::Data::Challenge" do
    to_create { |instance| FactoryBot::Storage.insert(:challenges, instance) }

    url { "https://acme-staging-v02.api.letsencrypt.org/acme/chall-v3/8894604784/UQwPnQ" }
    token { "W2HDDQSjMF2khMSCROy5cnItSo6qLRm4LnB5PhGFRoA" }
    status { "pending" }
    type { "_acme-challenge" }
    content do
      {
        record_name: "_acme-challenge",
        record_type: "TXT",
        record_content: "EqUWe7U1jaYEXVYBvojSm4MMpNSSqv5UsTvFCKkQKOo"
      }
    end
    created_at { Time.current }
  end
end
