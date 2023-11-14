# frozen_string_literal: true

RSpec.describe "#DELETE /session", :controller do
  subject { delete("/session") }

  before { header "Authentication", session.id }

  let(:session) { create(:session, account:) }
  let(:account) { create(:account) }

  it "should respond with empty response" do
    expect(subject.status).to eq(204)
    expect(response_body).to eq("")
  end
end
