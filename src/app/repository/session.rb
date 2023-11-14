# frozen_string_literal: true

module Application
  module Repository
    class Session < Base
      def find(id)
        query = table.where(id:)
        wrap_data(query.first, data:, request: query)
      end

      def create(session)
        session.created_at = Time.current
        session.id = table.insert(session.attributes_without_nils)
        session
      end

      def update(session)
        table.filter(id: session.id).update(session.changed) if session.changed?
        session
      end

      private

      def table
        DB[:sessions]
      end

      def data
        Data::Session
      end
    end
  end
end
