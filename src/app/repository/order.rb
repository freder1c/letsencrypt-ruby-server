# frozen_string_literal: true

module Application
  module Repository
    class Order < Base
      def create(order)
        order.created_at = Time.current
        order.id = table.insert(order.attributes_without_nils)
        order
      end

      private

      def table
        DB[:orders]
      end
    end
  end
end
