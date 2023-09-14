# frozen_string_literal: true

RSpec.shared_context :controller, controller: true do
  let(:response_body) do
    JSON.parse(subject.body)
  rescue JSON::ParserError
    subject.body
  end
end
