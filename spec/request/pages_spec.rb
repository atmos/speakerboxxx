require "rails_helper"

RSpec.describe "Speakerboxxx /install", type: :request do
  it "200s on /install" do
    get "/"
    expect(status).to eql(200)
  end
end

RSpec.describe "Speakerboxxx /support", type: :request do
  it "200s on /support" do
    get "/support"
    expect(status).to eql(200)
    expect(body).to include("mailto:atmos+speakerboxxx@atmos.org")
  end
end
