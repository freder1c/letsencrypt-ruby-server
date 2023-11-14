# frozen_string_literal: true

RSpec.describe "#POST /orders/:id/finalize", :controller, :auth do
  subject { post("/orders/#{order_id}/finalize") }

  let(:key) { create(:key, account:) }
  let(:order) { create(:order, account:, key:) }
  let(:order_id) { order.id }
  let(:acme_client) { instance_double(Acme::Client) }
  let(:acme_order) { instance_double(Acme::Client::Resources::Order) }

  before do
    allow(Acme::Client).to receive(:new).and_return(acme_client)
    allow(acme_client).to receive(:kid).and_return("https://acme-staging-v02.api.letsencrypt.org/acme/acct/120472004")
    allow(Acme::Client::Resources::Order).to receive(:new).and_return(acme_order)
    allow(acme_order).to receive(:finalize).and_return(true)
    allow(acme_order).to receive(:status).and_return("processing")
  end

  it "should respond with status processing" do
    expect(subject.status).to eq(202)
    expect(response_body.keys).to eq(%w[id key_id status created_at expires_at])
    expect(response_body["status"]).to eq("processing")
  end
end
