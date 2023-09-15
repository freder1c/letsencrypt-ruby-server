# frozen_string_literal: true

module Application
  module Repository
    class Session < Base
      def find(id)
        sql = table.where(id:)
        wrap_data(sql.first, data: Data::Session, request: sql)
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
    end
  end
end
