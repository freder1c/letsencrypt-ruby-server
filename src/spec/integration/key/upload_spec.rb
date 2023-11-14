# frozen_string_literal: true

RSpec.describe "#POST /keys/upload", :controller, :auth do
  subject { post("/keys/upload", params) }

  let(:file) { Rack::Test::UploadedFile.new(file_path) }
  let(:file_path) { Application.root_path.join("spec", "fixtures", "private.pem") }
  let(:params) { { file: } }

  it "should respond status created" do
    expect(subject.status).to eq(201)
    expect(response_body.keys).to eq(%w[id created_at])
  end

  context "when file is not a valid pem" do
    let(:file_path) { Application.root_path.join("spec", "fixtures", "text.txt") }

    it "should respond with unprocessable entity" do
      expect(subject.status).to eq(422)
      expect(response_body).to eq({
        "details" => { "file" => [{ "error" => "invalid_format" }] },
        "error" => "Unprocessable Entity"
      })
    end
  end
end
