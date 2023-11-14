# frozen_string_literal: true

module Application
  module Validator
    module Account
      UpdateLocale = Dry::Schema.Params do
        required(:locale).filled(:string)
      end
    end
  end
end
