# frozen_string_literal: true

module Application
  module Command
    module Key
      class Find < Base
        def call(id, options = {})
          raise Error::NotFound.new("key", id) if (key = Repository::Key.new(account).find(id, options)).nil?

          key
        end
      end
    end
  end
end
