# frozen_string_literal: true

module Application
  module Validator
    module Order
      Create = Dry::Schema.Params do
        required(:key_id).filled(:string)
      end
    end
  end
end
