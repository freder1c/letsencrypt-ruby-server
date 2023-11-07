# frozen_string_literal: true

module Application
  module Repository
    class Challenge < Base
      def all(options = {})
        page = Data::Page.from_params(options)

        sql = table
        sql = filter(sql, options)

        wrap_collection(sql.all, data:, page:)
      end

      def find(id, options = {})
        sql = table.where(id:)
        sql = filter(sql, options)
        wrap_data(sql.first, data:, request: sql)
      end

      def create(challenge)
        challenge.created_at = Time.current
        challenge.id = table.insert(Helper::Sequel.sanitize(challenge.attributes_without_nils))
        challenge.persisted!
      end

      private

      def table
        DB[:challenges]
      end

      def data
        Data::Challenge
      end

      def filter(sql, options)
        sql = sql.where(order_id: options[:order_id]) if options[:order_id]
        sql
      end
    end
  end
end
