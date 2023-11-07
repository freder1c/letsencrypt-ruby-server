# frozen_string_literal: true

RSpec.describe "/orders", :controller, :auth do
  describe "#POST" do
    subject { post("/orders", params.to_json) }

    let(:preferred_challenge_type) { "dns" }
    let(:client_authorization_instance) { instance_double(Acme::Client::Resources::Authorization) }
    let(:client_instance) { instance_double(Acme::Client) }
    let(:client_order_instance) { instance_double(Acme::Client::Resources::Order) }
    let(:client_dns_instance) { instance_double(Acme::Client::Resources::Challenges::DNS01) }
    let(:identifier) { "*.example.de" }
    let(:key) { create(:key, account:) }
    let(:key_id) { key.id }
    let(:params) { { key_id:, identifier:, preferred_challenge_type: } }

    before do
      allow(Acme::Client).to receive(:new).and_return(client_instance)
      allow(client_instance).to receive(:kid).and_return("https://acme-staging-v02.api.letsencrypt.org/acme/acct/120472004")
      allow(client_instance).to receive(:new_order).with(identifiers: [identifier]).and_return(client_order_instance)
      allow(client_order_instance).to receive(:authorizations).and_return([client_authorization_instance])
      allow(client_authorization_instance).to receive(:http).and_return(nil)
      allow(client_authorization_instance).to receive(:dns).and_return(client_dns_instance)
      allow(client_dns_instance).to receive(:url).and_return("https://acme-staging-v02.api.letsencrypt.org/acme/chall-v3/8894604784/UQwPnQ")
      allow(client_dns_instance).to receive(:token).and_return("W2HDDQSjMF2khMSCROy5cnItSo6qLRm4LnB5PhGFRoA")
      allow(client_dns_instance).to receive(:status).and_return("pending")
      allow(client_dns_instance).to receive(:record_name).and_return("_acme-challenge")
      allow(client_dns_instance).to receive(:record_type).and_return("TXT")
      allow(client_dns_instance).to receive(:record_content).and_return("EqUWe7U1jaYEXVYBvojSm4MMpNSSqv5UsTvFCKkQKOo")
    end

    it "should respond with token" do
      expect(subject.status).to eq(201)
      expect(response_body.keys).to eq(%w[id key_id status created_at])
      expect(response_body["status"]).to eq("created")
      expect(response_body["id"]).to match(Application::Validator.uuid_format)
    end

    context "key_id is missing" do
      let(:key_id) { SecureRandom.hex(12) }

      it "should respond with unprocessable entity status" do
        expect(subject.status).to eq(422)
      end
    end
  end
end
