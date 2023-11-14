# frozen_string_literal: true

RSpec.describe "PUT /account/locale", :controller, :auth do
  subject { put("/account/locale", params.to_json) }

  let(:locale) { "de-DE" }
  let(:params) { { locale: } }

  it "should respond with ok no content" do
    expect(subject.status).to eq(204)
    expect(response_body).to eq("")
  end
end
