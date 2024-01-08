# frozen_string_literal: true

FactoryBot.define do
  factory :key, class: "Application::Data::Key" do
    to_create { |instance| FactoryBot::Storage.insert(:keys, instance, except: [:file]) }

    created_at { Time.current }

    trait :account do
      path = Application.root_path.join("spec", "fixtures", "account.pem")

      id { Digest::SHA512.hexdigest(OpenSSL::PKey::RSA.new(File.read(path)).to_s) }
      file { OpenSSL::PKey::RSA.new(File.read(path)) }

      after(:create) { |key| upload_file(key) }
    end

    trait :private do
      path = Application.root_path.join("spec", "fixtures", "private.pem")

      id { Digest::SHA512.hexdigest(OpenSSL::PKey::RSA.new(File.read(path)).to_s) }
      file { OpenSSL::PKey::RSA.new(File.read(path)) }

      after(:create) { |key| upload_file(key) }
    end
  end
end

def upload_file(key)
  client = Aws::S3::Client.new(force_path_style: true)
  client.put_object(
    bucket: Application.s3_bucket_name,
    key: "#{key.account_id}/#{key.id}.pem",
    body: key.file.to_s
  )
end
