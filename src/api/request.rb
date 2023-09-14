# frozen_string_literal: true

module Application
  class Request
    attr_accessor :token
    attr_reader :body, :params

    def initialize(token:, body:, params:)
      @token = token
      @body = body
      @params = params
    end

    def payload
      JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError
      {}
    end
  end
end
