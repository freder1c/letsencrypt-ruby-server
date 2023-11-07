# frozen_string_literal: true

module Application
  module Repository
    class Key < Base
      def find(id, options = {})
        sql = table.where(id:, account_id:)
        key = wrap_data(sql.first, data: Data::Key, request: sql)
        return key unless key.present?

        get_file_for(key) if options[:with_file]
        key
      end

      def create(key)
        s3_client.put_object(bucket: Application.s3_bucket_name, key: storage_key(key), body: key.file.to_s)
        key.created_at = Time.current
        key.id = table.insert(key.attributes_without_nils.except(:file))
        key.persisted!
      end

      private

      def table
        DB[:keys]
      end

      def storage_key(key)
        "#{key.account_id}/#{key.id}.pem"
      end

      def get_file_for(key)
        file = s3_client.get_object(bucket: Application.s3_bucket_name, key: storage_key(key))
        key.file = OpenSSL::PKey::RSA.new(file.body.read)
      end
    end
  end
end
