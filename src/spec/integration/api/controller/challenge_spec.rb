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
end
