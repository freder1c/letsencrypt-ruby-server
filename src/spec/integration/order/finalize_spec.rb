# frozen_string_literal: true

RSpec.describe "#POST /orders/:id/finalize", :controller, :auth do
  subject { post("/orders/#{order_id}/finalize") }

  let(:key) { create(:key, :private, account:) }
  let(:order) { create(:order, account:, key:) }
  let(:order_id) { order.id }
  let(:acme_client) { instance_double(Acme::Client) }
  let(:acme_order) { instance_double(Acme::Client::Resources::Order) }

  let(:client_order_hash) do
    {
      url: "https://acme-staging-v02.api.letsencrypt.org/acme/order/120472004/12107311774",
      status: "processing",
      expires: "2023-11-14T18:52:09Z",
      finalize_url: "https://acme-staging-v02.api.letsencrypt.org/acme/finalize/120472004/12107311774",
      authorization_urls: ["https://acme-staging-v02.api.letsencrypt.org/acme/authz-v3/9328628434"],
      identifiers: [{ type: "dns", value: "*.example.com" }],
      certificate_url: "https://acme-staging-v02.api.letsencrypt.org/acme/finalize/120472004/12107311774"
    }
  end

  before do
    allow(Acme::Client).to receive(:new).and_return(acme_client)
    allow(acme_client).to receive(:kid).and_return("https://acme-staging-v02.api.letsencrypt.org/acme/acct/120472004")
    allow(Acme::Client::Resources::Order).to receive(:new).and_return(acme_order)
    allow(acme_order).to receive(:finalize).and_return(true)
    allow(acme_order).to receive(:to_h).and_return(client_order_hash)
  end

  it "should respond with status processing" do
    expect(subject.status).to eq(202)
    expect(response_body.keys).to eq(%w[id key_id status certificate_url created_at expires_at])
    expect(response_body["status"]).to eq("processing")
  end
end
