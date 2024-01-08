# frozen_string_literal: true

RSpec.describe "#GET /keys", :controller, :auth do
  subject { get("/keys") }

  let(:id) { challenge.id }
  let!(:key) { create(:key, :private, account:) }
  let(:key_created_at_string_timestamp) { key.created_at.strftime("%Y-%m-%d %H:%M:%S.%L") }

  it "should respond with collection of keys" do
    expect(subject.status).to eq(200)
    expect(response_body.size).to eq(2)
    expect(response_body.map { |k| k["id"] }).to eq([key.id, account_key.id])
    expect(subject.headers["page-after"]).to eq(nil)
    expect(subject.headers["page-size"]).to eq(50)
  end

  context "when paging headers are given" do
    before do
      header "Page-After", key_created_at_string_timestamp
      header "Page-Size", 1
    end

    it "should respond with partial collection of keys" do
      expect(subject.status).to eq(200)
      expect(response_body.size).to eq(1)
      expect(subject.headers["page-after"]).to eq(key_created_at_string_timestamp)
      expect(subject.headers["page-size"]).to eq(1)
    end
  end
end
