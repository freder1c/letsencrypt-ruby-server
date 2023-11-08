# frozen_string_literal: true

FactoryBot.define do
  factory :challenge, class: "Application::Data::Challenge" do
    to_create { |instance| FactoryBot::Storage.insert(:challenges, instance) }

    url { "https://acme-staging-v02.api.letsencrypt.org/acme/chall-v3/9328026594/BlKBUQ" }
    token { "vkVgo7p1SeH6jXXFUQa7qM8ukdrD28JMMMoZvySyYPQ" }
    status { "pending" }
    type { "dns" }
    content do
      {
        record_name: "_acme-challenge",
        record_type: "TXT",
        record_content: "GwTCbznyDIp-59zO7D6HIOMyYfeWaBQlLw9xfbfENu0"
      }
    end
    created_at { Time.current }
  end
end
