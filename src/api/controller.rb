# frozen_string_literal: true

module Application
  module Controller
    class Base
      attr_reader :request, :employment

      def initialize(request)
        @request = request
      end
    end
  end
end
