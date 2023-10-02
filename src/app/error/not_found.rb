# frozen_string_literal: true

module Application
  module Error
    class NotFound < StandardError
      attr_reader :record, :id

      def initialize(record, id)
        @record = record
        @id = id
        super("Record not found.")
      end

      def details
        { record.to_sym => [{ error: :not_found, value: id }] }
      end
    end
  end
end
