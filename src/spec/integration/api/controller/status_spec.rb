# frozen_string_literal: true

RSpec.describe "/status", :controller do
  describe "#GET" do
    subject { get("/status") }

    it "should respond with ok" do
      expect(subject.status).to eq(200)
      expect(response_body.keys).to eq(%w[status running_since])
      expect(response_body["status"]).to eq("ok")
    end
  end
end
