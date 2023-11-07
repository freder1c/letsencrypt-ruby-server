# frozen_string_literal: true

RSpec.describe "/orders/:id/challenges", :controller, :auth do
  describe "#GET /" do
    subject { get("/orders/#{order_id}/challenges") }

    let!(:challenge) { create(:challenge, order:) }
    let(:id) { challenge.id }
    let(:key) { create(:key, account:) }
    let(:order) { create(:order, account:, key:) }
    let(:order_id) { order.id }

    it "should respond with collection of challenges" do
      expect(subject.status).to eq(200)
      expect(response_body.first["id"]).to eq(id)
      expect(subject.headers["page-number"]).to eq(1)
      expect(subject.headers["page-size"]).to eq(50)
    end
  end

  describe "#GET /:challenge_id" do
    subject { get("/orders/#{order_id}/challenges/#{id}") }

    let(:challenge) { create(:challenge, order:) }
    let(:id) { challenge.id }
    let(:key) { create(:key, account:) }
    let(:order) { create(:order, account:, key:) }
    let(:order_id) { order.id }

    it "should respond with challenge payload" do
      expect(subject.status).to eq(200)
      expect(response_body.keys).to eq(%w[id order_id url token status type content created_at])
    end
  end

  describe "#POST /:challenge_id/validate" do
    subject { post("/orders/#{order_id}/challenges/#{id}/validate") }

    let(:challenge) { create(:challenge, order:) }
    let(:client_instance) { instance_double(Acme::Client) }
    let(:dns_challenge_instance) { instance_double(Acme::Client::Resources::Challenges::DNS01) }
    let(:id) { challenge.id }
    let(:key) { create(:key, account:) }
    let(:order) { create(:order, account:, key:) }
    let(:order_id) { order.id }

    before do
      allow(Acme::Client).to receive(:new).and_return(client_instance)
      allow(Acme::Client::Resources::Challenges::DNS01).to receive(:new)
        .with(client_instance, status: challenge.status, url: challenge.url, token: challenge.token)
        .and_return(dns_challenge_instance)
      allow(dns_challenge_instance).to receive(:request_validation).and_return(true)
    end

    it "should respond with challenge payload" do
      expect(subject.status).to eq(202)
      expect(response_body).to eq("")
    end
  end
end
