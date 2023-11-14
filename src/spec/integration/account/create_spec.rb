# frozen_string_literal: true

RSpec.describe "#POST /account", :controller do
  subject { post("/account", params.to_json) }

  let(:email) { "test@example.com" }
  let(:params) { { email:, password: } }
  let(:password) { "1!Secret" }

  it "should respond with token" do
    expect(subject.status).to eq(201)
    expect(response_body.keys).to eq(%w[email locale key_id])
    expect(response_body["locale"]).not_to eq(nil)
  end

  context "when email is invalid" do
    let(:email) { "invalid.com" }

    it "should respond with unprocessable entity" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "email" => [{ "error" => "invalid_format" }] },
        "error" => "Unprocessable Entity"
      })
    end
  end

  context "when password is invalid" do
    let(:password) { "not-valid" }

    it "should respond with unprocessable entity" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "password" => [{ "error" => "invalid_format" }] },
        "error" => "Unprocessable Entity"
      })
    end
  end
end
