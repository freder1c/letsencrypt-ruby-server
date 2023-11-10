# frozen_string_literal: true

RSpec.describe "PATCH /account", :controller, :auth do
  describe "#PATCH" do
    subject { patch("/account", params.to_json) }

    let(:params) { { locale: "de-DE" } }

    fit "should respond with updated account data" do
      expect(account.locale).to eq("en-US")
      expect(subject.status).to eq(200)
      expect(response_body["locale"]).to eq("de-DE")
    end
  end
end
