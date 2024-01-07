# frozen_string_literal: true

RSpec.describe "#GET /orders/:order_id/challenges/:challenge_id", :controller, :auth do
  subject { get("/orders/#{order_id}/challenges/#{id}") }

  let(:challenge) { create(:challenge, order:) }
  let(:id) { challenge.id }
  let(:key) { create(:key, :private, account:) }
  let(:order) { create(:order, account:, key:) }
  let(:order_id) { order.id }

  it "should respond with challenge payload" do
    expect(subject.status).to eq(200)
    expect(response_body.keys).to eq(%w[id order_id status type content created_at])
  end
end
