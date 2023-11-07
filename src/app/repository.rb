# frozen_string_literal: true

require "aws-sdk-s3"

module Application
  module Repository
    class Base
      attr_reader :account

      def initialize(account = nil)
        @account = account
      end

      private

      def account_id
        account.id
      end

      def wrap_data(attributes, data:, request:)
        return Data::NullRecord.new(request:) if attributes.nil?

        data.new(attributes)
      end

      def wrap_collection(sql, data:, page:)
        Data::Collection.new(sql.map { |attr| data.new(attr) }, page: page)
      end

      def s3_client
        @s3_client ||= Aws::S3::Client.new(force_path_style: true)
      end

      def default_sql_order
        Sequel.desc(:created_at)
      end
    end
  end
end
