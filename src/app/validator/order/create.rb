# frozen_string_literal: true

module Application
  module Validator
    module Order
      Create = Dry::Schema.Params do
        required(:key_id).filled(:string)
        required(:identifier).filled(:string)
        optional(:preferred_challenge_type).value(included_in?: %w[http dns])
      end
    end
  end
end
