# frozen_string_literal: true

module Application
  module Data
    class Page < Base
      attribute :number, default: 1
      attribute :size, default: 50

      def self.from_params(params)
        attr = {}
        attr[:number] = params.dig(:page, :number).to_i if params.dig(:page, :number)
        attr[:size] = params.dig(:page, :size).to_i if params.dig(:page, :size)

        new(attr)
      end

      def offset
        (number.to_i - 1) * size.to_i
      end
    end
  end
end
