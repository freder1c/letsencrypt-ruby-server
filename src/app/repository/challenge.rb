# frozen_string_literal: true

module Application
  module Repository
    class Challenge < Base
      def create(challenge)
        challenge.created_at = Time.current
        challenge.id = table.insert(challenge.attributes_without_nils)
        challenge.persisted!
      end

      private

      def table
        DB[:challenges]
      end
    end
  end
end
