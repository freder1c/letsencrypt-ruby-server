# frozen_string_literal: true

RSpec.describe "#POST /orders", :controller, :auth do
  subject { post("/orders", params.to_json) }

  let(:acme_auth) { instance_double(Acme::Client::Resources::Authorization) }
  let(:acme_client) { instance_double(Acme::Client) }
  let(:acme_dns) { instance_double(Acme::Client::Resources::Challenges::DNS01) }
  let(:acme_order) { instance_double(Acme::Client::Resources::Order) }
  let(:identifier) { "*.shedulr.io" }
  let(:key) { create(:key, account:) }
  let(:key_id) { key.id }
  let(:params) { { key_id:, identifier:, preferred_challenge_type: } }
  let(:preferred_challenge_type) { "dns" }

  let(:client_order_hash) do
    {
      url: "https://acme-staging-v02.api.letsencrypt.org/acme/order/120472004/12107311774",
      status: "pending",
      expires: "2023-11-14T18:52:09Z",
      finalize_url: "https://acme-staging-v02.api.letsencrypt.org/acme/finalize/120472004/12107311774",
      authorization_urls: ["https://acme-staging-v02.api.letsencrypt.org/acme/authz-v3/9328628434"],
      identifiers: [{ type: "dns", value: "*.example.com" }],
      certificate_url: nil
    }
  end

  before do
    allow(Acme::Client).to receive(:new).and_return(acme_client)
    allow(acme_client).to receive(:kid).and_return("https://acme-staging-v02.api.letsencrypt.org/acme/acct/120472004")
    allow(acme_client).to receive(:new_order).with(identifiers: [identifier]).and_return(acme_order)
    allow(acme_order).to receive(:authorizations).and_return([acme_auth])
    allow(acme_order).to receive(:to_h).and_return(client_order_hash)
    allow(acme_auth).to receive(:http).and_return(nil)
    allow(acme_auth).to receive(:dns).and_return(acme_dns)
    allow(acme_dns).to receive(:url)
      .and_return("https://acme-staging-v02.api.letsencrypt.org/acme/chall-v3/8894604784/UQwPnQ")
    allow(acme_dns).to receive(:token).and_return("W2HDDQSjMF2khMSCROy5cnItSo6qLRm4LnB5PhGFRoA")
    allow(acme_dns).to receive(:status).and_return("pending")
    allow(acme_dns).to receive(:record_name).and_return("_acme-challenge")
    allow(acme_dns).to receive(:record_type).and_return("TXT")
    allow(acme_dns).to receive(:record_content).and_return("EqUWe7U1jaYEXVYBvojSm4MMpNSSqv5UsTvFCKkQKOo")
  end

  it "should respond with token" do
    expect(subject.status).to eq(201)
    expect(response_body.keys).to eq(%w[id key_id status created_at expires_at])
    expect(response_body["status"]).to eq("pending")
    expect(response_body["id"]).to match(Application::Validator.uuid_format)
  end

  context "when key_id is missing" do
    let(:key_id) { SecureRandom.hex(12) }

    it "should respond with unprocessable entity status" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "key_id" => [{ "error" => "invalid", "value" => key_id }] },
        "error" => "Unprocessable Entity"
      })
    end
  end

  context "when key_id is same as account key_id" do
    before do
      Application::DB[:accounts].filter(id: account.id).update(key_id:)
    end

    it "should respond with unprocessable entity status" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "key_id" => [{ "error" => "cant_be_same_as_account_key", "value" => key_id }] },
        "error" => "Unprocessable Entity"
      })
    end
  end
end
