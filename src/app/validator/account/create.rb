# frozen_string_literal: true

module Application
  module Validator
    module Account
      Create = Dry::Schema.Params do
        required(:email).value(format?: Validator.email_format)
        required(:password).value(format?: Validator.password_format)
        optional(:locale).filled(:string)
      end
    end
  end
end
