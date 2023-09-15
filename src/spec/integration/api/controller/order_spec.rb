# frozen_string_literal: true

RSpec.describe "/order", :controller, :auth do
  describe "#POST" do
    subject { post("/order") }

    it "should respond with token" do
      expect(subject.status).to eq(201)
      expect(response_body.keys).to eq(%w[id status created_at])
      expect(response_body["status"]).to eq("created")
      expect(response_body["id"]).to match(Application::Validator.uuid_format)
    end
  end
end
