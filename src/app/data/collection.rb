# frozen_string_literal: true

module Application
  module Data
    class Collection < Array
      attr_reader :page

      def initialize(array, page: Page.new)
        @page = page

        super(array)
      end

      def page_size
        page.size
      end

      def page_number
        page.number
      end
    end
  end
end
