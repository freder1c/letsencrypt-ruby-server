# frozen_string_literal: true

RSpec.describe "#POST /session", :controller do
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

  context "when email is invalid" do
    let(:email) { "invalid@email.com" }

    it "should respond with unauthorized status" do
      expect(subject.status).to eq(401)
    end
  end

  context "when password is invalid" do
    let(:password) { "not-valid" }

    it "should respond with unauthorized status and increase failed attempts" do
      expect(subject.status).to eq(401)
      expect(Application::DB[:accounts].where(id: account.id).first[:failed_attempts]).to eq(1)
    end
  end

  context "when account is locked" do
    let(:account) { create(:account, locked_at: Time.current) }

    it "should respond with unprocessable entity status" do
      expect(subject.status).to eq(403)
    end
  end

  context "when email is missing" do
    let(:email) { nil }

    it "should respond with unprocessable entity status" do
      expect(subject.status).to eq(422)
    end
  end
end
