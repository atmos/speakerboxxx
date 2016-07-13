require "rails_helper"

RSpec.describe "Speakerboxxx GET /auth/slack/callback", type: :request do
  it "creates a user on the organization when authenticated" do
    OmniAuth.config.mock_auth[:slack] = slack_omniauth_hash_for_atmos
    expect do
      get "/auth/slack"
      expect(status).to eql(302)
      uri = Addressable::URI.parse(headers["Location"])
      expect(uri.host).to eql("www.example.com")
      expect(uri.path).to eql("/auth/slack/callback")
      follow_redirect!
    end.to change { SlackHQ::Team.count }.by(1)

    team = SlackHQ::Team.first
    user = team.users.first

    expect(user.slack_user_name).to eql("atmos")
    expect(team.bot_token).to eql("xoxo-hugs-n-kisses")
  end

  it "creates a user and stores a token on the organization when installed" do
    OmniAuth.config.mock_auth[:slack_install] = slack_omniauth_hash_for_atmos
    expect do
      get "/auth/slack_install"
      expect(status).to eql(302)
      uri = Addressable::URI.parse(headers["Location"])
      expect(uri.host).to eql("www.example.com")
      expect(uri.path).to eql("/auth/slack_install/callback")
      follow_redirect!
    end.to change { SlackHQ::Team.count }.by(1)

    team = SlackHQ::Team.first
    user = team.users.first

    expect(user.slack_user_name).to eql("atmos")
    expect(team.bot_token).to eql("xoxo-hugs-n-kisses")
  end
end
