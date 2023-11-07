# frozen_string_literal: true

module Application
  module Data
    class Challenge < Base
      attribute :id
      attribute :order_id
      attribute :url
      attribute :token
      attribute :status
      attribute :type
      attribute :content
      attribute :created_at

      def order=(order)
        raise Error::WrongAssignement unless order.is_a?(Data::Order)

        self.order_id = order.id
      end
    end
  end
end
