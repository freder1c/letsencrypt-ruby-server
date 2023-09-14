# frozen_string_literal: true

RSpec.describe "/session", :controller do
  describe "#POST" do
    subject { post("/session", params.to_json) }

    let(:account) { create(:account) }
    let(:email) { account.email }
    let(:params) { { email:, password: } }
    let(:password) { "1!Secret" }

    it "should respond with token" do
      expect(subject.status).to eq(201)
      expect(response_body.keys).to eq(%w[token])
      expect(response_body["token"]).to match(Application::Validator.uuid_format)
    end

    context "email is invalid" do
      let(:email) { "invalid@email.com" }

      it "should respond with unauthorized status" do
        expect(subject.status).to eq(401)
      end
    end

    context "email is missing" do
      let(:email) { nil }

      it "should respond with unprocessable entity status" do
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
