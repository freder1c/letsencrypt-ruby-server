# frozen_string_literal: true

module Application
  module Validator
    module Session
      Create = Dry::Schema.Params do
        required(:email).value(format?: Validator.email_format)
        required(:password).value(format?: Validator.password_format)
      end
    end
  end
end
