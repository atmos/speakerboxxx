require "rails_helper"

RSpec.describe "Speakerboxxx GET /install", type: :request do
  after  { OmniAuth.config.test_mode = true }
  before { OmniAuth.config.test_mode = false }

  it "sends you to slack with appropriate scopes requested to install" do
    get "/install"
    expect(status).to eql(302)
    uri = Addressable::URI.parse(headers["Location"])
    expect(uri.host).to eql("www.example.com")
    expect(uri.path).to eql("/auth/slack_install")

    follow_redirect!
    uri = Addressable::URI.parse(headers["Location"])
    expect(uri.host).to eql("slack.com")
    expect(uri.path).to eql("/oauth/authorize")
    expect(uri.query_values["scope"]).to eql("identify,commands,bot")
  end

  it "sends you to slack with appropriate scopes requested to authenticate" do
    get "/auth/slack"
    expect(status).to eql(302)
    uri = Addressable::URI.parse(headers["Location"])
    expect(uri.host).to eql("slack.com")
    expect(uri.path).to eql("/oauth/authorize")
    expect(uri.query_values["scope"]).to eql("identity.basic,users:read")
  end
end
