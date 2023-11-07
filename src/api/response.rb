# frozen_string_literal: true

module Application
  class Response
    attr_reader :status, :type, :page

    def initialize(status:, body:, type: "application/json", page: nil)
      @status = status
      @body = body
      @type = type
      @page = page
    end

    def body
      if type == "application/json"
        @body&.to_json
      else
        @body
      end
    end

    def json
      body&.to_json
    end
  end
end
