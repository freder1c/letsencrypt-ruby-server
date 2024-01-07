# frozen_string_literal: true

RSpec.shared_context :controller, controller: true do
  let(:response_body) do
    JSON.parse(subject.body)
  rescue JSON::ParserError
    subject.body
  end
end

RSpec.shared_context :auth_controller, auth: true do
  let(:account) { create(:account) }
  let(:session) { create(:session, account_id: account.id) }

  before do
    header "Authentication", session.id
    key = create(:key, :account, account:)
    Application::DB[:accounts].filter(id: account.id).update(key_id: key.id)
  end
end
