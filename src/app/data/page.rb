# frozen_string_literal: true

module Application
  module Data
    class Page < Base
      attribute :after, default: nil
      attribute :size, default: 50

      alias limit size

      def self.from_params(params)
        attr = {}
        attr[:after] = params[:page_after] if params[:page_after]
        attr[:size] = params[:page_size]&.to_i if params[:page_size]

        new(attr)
      end
    end
  end
end
