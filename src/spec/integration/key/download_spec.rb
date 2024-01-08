# frozen_string_literal: true

RSpec.describe "#GET /keys/:id/download", :controller, :auth do
  subject { get("/keys/#{key_id}/download") }

  let(:key) { create(:key, :private, account:) }
  let(:key_id) { key.id }

  it "should respond download key file" do
    expect(subject.status).to eq(200)
    expect(subject.body).to eq(key.file.to_s)
  end

  context "when key_id is invalid" do
    let(:key_id) { SecureRandom.hex(10) }

    it "should respond not found status" do
      expect(subject.status).to eq(404)
    end
  end
end
