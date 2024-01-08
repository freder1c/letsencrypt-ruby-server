# frozen_string_literal: true

RSpec.describe "#POST /orders/:order_id/challenges/:challenge_id/validate", :controller, :auth do
  subject { post("/orders/#{order_id}/challenges/#{id}/validate") }

  let(:challenge) { create(:challenge, order:) }
  let(:client_instance) { instance_double(Acme::Client) }
  let(:dns_challenge_instance) { instance_double(Acme::Client::Resources::Challenges::DNS01) }
  let(:id) { challenge.id }
  let(:key) { create(:key, :private, account:) }
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
