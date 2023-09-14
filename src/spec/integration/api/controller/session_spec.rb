# frozen_string_literal: true

RSpec.describe "/session", :controller do
  describe "#POST" do
    subject { post("/session") }

    it "should respond with token" do
      expect(subject.status).to eq(201)
      expect(response_body.keys).to eq(%w[token])
      expect(response_body["token"]).to match(Application::Validator.uuid_format)
    end
  end

  describe "#DELETE" do
    subject { delete("/session") }

    it "should respond with empty response" do
      expect(subject.status).to eq(204)
      expect(response_body).to eq("")
    end
  end
end
