# frozen_string_literal: true

module Application
  module Presenter
    class Base
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def present!
        object.instance_of?(Data::Collection) ? collection : record(object)
      end

      private

      def collection
        object.map { |entry| record(entry) }
      end
    end
  end
end
