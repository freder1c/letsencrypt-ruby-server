# frozen_string_literal: true

FactoryBot.define do
  factory :key, class: "Application::Data::Key" do
    to_create { |instance| FactoryBot::Storage.insert(:keys, instance) }

    id { Digest::SHA512.hexdigest(OpenSSL::PKey::RSA.new(File.read("spec/fixtures/private.pem")).to_s) }
    created_at { Time.current }

    after(:create) do |key|
      client = Aws::S3::Client.new(force_path_style: true)
      path = Application.root_path.join("spec", "fixtures", "private.pem")
      key.file = OpenSSL::PKey::RSA.new(File.read(path))
      client.put_object(bucket: Application.s3_bucket_name, key: "#{key.account_id}/#{key.id}.pem", body: key.file.to_s)
    end
  end
end
