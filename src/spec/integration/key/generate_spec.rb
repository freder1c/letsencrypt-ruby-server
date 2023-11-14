# frozen_string_literal: true

RSpec.describe "#POST /keys/generate", :controller, :auth do
  subject { post("/keys/generate", params.to_json) }

  let(:size) { 4096 }
  let(:params) { { size: } }

  it "should respond status created" do
    expect(subject.status).to eq(201)
    expect(response_body.keys).to eq(%w[id created_at])
  end

  context "when size is invalid" do
    let(:size) { 1000 }

    it "should respond with unprocessable entity" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "size" => [{ "error" => "not_in_list", "valid_options" => "2048, 4096" }] },
        "error" => "Unprocessable Entity"
      })
    end
  end
end
