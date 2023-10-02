# frozen_string_literal: true

module Application
  module Error
    class EmailNotFound < StandardError
      def initialize
        super("Email not found.")
      end
    end
  end
end
