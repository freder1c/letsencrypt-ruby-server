# frozen_string_literal: true

RSpec.describe "PUT /account/key", :controller, :auth do
  subject { put("/account/key", params.to_json) }

  let(:key) { create(:key, :private, account:) }
  let(:key_id) { key.id }
  let(:params) { { key_id: } }

  it "should respond with ok no content" do
    expect(subject.status).to eq(204)
    expect(response_body).to eq("")
  end

  context "when key does not exist" do
    let(:key_id) { SecureRandom.hex(10) }

    it "should respond with updated key for account" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "key_id" => [{ "error" => "invalid", "value" => key_id }] },
        "error" => "Unprocessable Entity"
      })
    end
  end

  context "when key was used for an order before" do
    let!(:order) { create(:order, account:, key_id:) }

    it "should respond with updated key for account" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "key_id" => [{ "error" => "used_for_order", "value" => key_id }] },
        "error" => "Unprocessable Entity"
      })
    end
  end
end
