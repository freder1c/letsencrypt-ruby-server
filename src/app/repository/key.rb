# frozen_string_literal: true

module Application
  module Repository
    class Key < Base
      def find(id)
        sql = table.where(id:, account_id: account.id)
        wrap_data(sql.first, data: Data::Key, request: sql)
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
        "#{key.account_id}/#{key.hash}.pem"
      end
    end
  end
end
