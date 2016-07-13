Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_OAUTH_ID"], ENV["GITHUB_OAUTH_SECRET"], scope: "user,admin:org_hook"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, ENV["SLACK_OAUTH_ID"], ENV["SLACK_OAUTH_SECRET"], scope: "identity.basic"
  provider :slack, ENV["SLACK_OAUTH_ID"], ENV["SLACK_OAUTH_SECRET"], scope: "identify,commands,bot", name: :slack_install
end
