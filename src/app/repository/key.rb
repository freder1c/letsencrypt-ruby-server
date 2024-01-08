# frozen_string_literal: true

module Application
  module Repository
    class Key < Base
      def all(options = {})
        page = Data::Page.from_params(options)
        query = table.then { |sql| filter(sql, options) }.then { |sql| order(sql) }.then { |sql| paginate(sql, page) }
        wrap_collection(query.all, data:, page:)
      end

      def find(id, options = {})
        query = table.where(id:).then { |sql| filter(sql, options) }
        key = wrap_data(query.first, data:, request: query)
        return key if key.nil?

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

      def data
        Data::Key
      end

      def filter(query, options)
        query.then { |sql| options[:account_id] ? sql.where(account_id: options[:account_id]) : sql }
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
