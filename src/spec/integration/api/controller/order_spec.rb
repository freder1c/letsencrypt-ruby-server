# frozen_string_literal: true

RSpec.describe "/orders", :controller, :auth do
  describe "#POST" do
    subject { post("/orders", params.to_json) }

    let(:key) { create(:key, account:) }
    let(:key_id) { key.id }
    let(:params) { { key_id: } }

    it "should respond with token" do
      expect(subject.status).to eq(201)
      expect(response_body.keys).to eq(%w[id key_id status created_at])
      expect(response_body["status"]).to eq("created")
      expect(response_body["id"]).to match(Application::Validator.uuid_format)
    end

    context "key_id is missing" do
      let(:key_id) { SecureRandom.hex(12) }

      it "should respond with unprocessable entity status" do
        expect(subject.status).to eq(422)
      end
    end
  end
end
