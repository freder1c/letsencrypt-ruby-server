# frozen_string_literal: true

module Application
  module Validator
    module Account
      Update = Dry::Schema.Params do
        optional(:email).filled(:string)
        optional(:locale).filled(:string)
        optional(:key_id).filled(:string)
      end
    end
  end
end
