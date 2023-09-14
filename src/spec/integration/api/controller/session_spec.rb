# frozen_string_literal: true

RSpec.describe "/session", :controller do
  describe "#POST" do
    subject { post("/session", params.to_json) }

    let(:params) { { email:, password: } }
    let(:email) { "text@example.com" }
    let(:password) { "1!Secret" }

    it "should respond with token" do
      expect(subject.status).to eq(201)
      expect(response_body.keys).to eq(%w[token])
      expect(response_body["token"]).to match(Application::Validator.uuid_format)
    end

    context "email has invalid format" do
      let(:email) { "text.com" }
      let(:password) { "123" }

      it "should raise unprocessable entity error" do
        expect(subject.status).to eq(422)
      end
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
