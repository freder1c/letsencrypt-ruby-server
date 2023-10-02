# frozen_string_literal: true

RSpec.describe "/keys", :controller, :auth do
  describe "#POST /generate" do
    subject { post("/keys/generate") }

    it "should respond with token" do
      expect(subject.status).to eq(201)
      expect(response_body.keys).to eq(%w[id created_at])
    end
  end
end
