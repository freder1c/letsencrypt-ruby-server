# frozen_string_literal: true

module Application
  module Presenter
    class Base
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def present!
        record(object)
      end
    end
  end
end
