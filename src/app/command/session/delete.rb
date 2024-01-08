# frozen_string_literal: true

module Application
  module Command
    module Session
      class Delete
        def call(id)
          session = repo.find(id)

          unless session.nil?
            session.expires_at = Time.current
            repo.update(session)
          end

          session
        end

        private

        def repo
          @repo ||= Repository::Session.new(nil)
        end
      end
    end
  end
end
