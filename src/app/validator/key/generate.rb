# frozen_string_literal: true

module Application
  module Validator
    module Key
      Generate = Dry::Schema.Params do
        optional(:size).value(included_in?: [2048, 4096])
      end
    end
  end
end
