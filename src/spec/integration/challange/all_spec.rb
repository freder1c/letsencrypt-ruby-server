# frozen_string_literal: true

RSpec.describe "#GET /orders/:id/challenges", :controller, :auth do
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
