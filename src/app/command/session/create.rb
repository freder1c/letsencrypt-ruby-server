# frozen_string_literal: true

module Application
  module Command
    module Session
      class Create
        def call(params = {})
          _params = Validator.validate(Validator::Session::Create, params)

          Data::Session.new(id: SecureRandom.uuid)
        end
      end
    end
  end
end
