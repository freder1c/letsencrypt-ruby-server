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
  let(:account_key) { create(:key, :account, account:) }

  before do
    header "Authentication", session.id
    Application::DB[:accounts].filter(id: account.id).update(key_id: account_key.id)
  end
end
