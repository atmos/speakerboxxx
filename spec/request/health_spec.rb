require "rails_helper"

RSpec.describe "Speakerboxxx /health", type: :request do
  it "200s on /health" do
    get "/health"
    data = JSON.parse(body)
    expect(status).to eql(200)
    expect(data["name"]).to eql("speakerboxxx/the-love-below")
  end
end
