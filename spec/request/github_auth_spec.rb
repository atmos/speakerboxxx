require "rails_helper"

RSpec.describe "Speakerboxxx GET /auth/github/callback", type: :request do
  it "creates the username and login on the authenticated user when successful" do
    token = "xoxp-9101111159-5657146422-59735495733-3186a13efg"
    stub_json_request(:get,
                      "https://slack.com/api/users.identity?token=#{token}",
                      fixture_data("slack.com/identity"))

    SlackHQ::Team.create(team_id: "T092F92CG",
                         bot_user_id: "U9MG9BRL6",
                         bot_token: "xoxo-woop-woop")

    OmniAuth.config.mock_auth[:slack] = slack_omniauth_hash_for_toolskai
    OmniAuth.config.mock_auth[:github] = github_omniauth_hash_for_toolskai

    expect do
      get "/auth/slack"
      expect(status).to eql(302)
      uri = Addressable::URI.parse(headers["Location"])
      expect(uri.host).to eql("www.example.com")
      expect(uri.path).to eql("/auth/slack/callback")
      follow_redirect!
    end.to change { SlackHQ::Team.count }.by(0)
    
    expect do
      get "/auth/github"
      expect(status).to eql(302)
      uri = Addressable::URI.parse(headers["Location"])
      expect(uri.host).to eql("www.example.com")
      expect(uri.path).to eql("/auth/github/callback")
      follow_redirect!
    end.to change { SlackHQ::Team.count }.by(0)

    team = SlackHQ::Team.first
    user = team.users.first

    expect(user.slack_user_name).to eql("Toolskai")
    expect(user.github_login).to eql("toolskai")
  end
end
