# frozen_string_literal: true

RSpec.describe "#POST /orders/:order_id/challenges/:challenge_id/resolve", :controller, :auth do
  subject { post("/orders/#{order_id}/challenges/#{id}/resolve") }

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
    allow(dns_challenge_instance).to receive(:reload).and_return(true)
    allow(dns_challenge_instance).to receive(:status).and_return("valid")
  end

  it "should respond with challenge payload" do
    expect(subject.status).to eq(200)
    expect(response_body.keys).to eq(%w[id order_id status type content created_at])
    expect(response_body["status"]).to eq("valid")
  end
end
