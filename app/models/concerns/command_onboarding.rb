# Module for handling redirection for onboarding users
module CommandOnboarding
  extend ActiveSupport::Concern

  included do
  end

  # Things exposed to the included class as class methods
  module ClassMethods
  end

  def auth_url_prefix
    "https://#{ENV['HOSTNAME']}/auth"
  end

  def slack_auth_url
    "#{auth_url_prefix}/slack?origin=#{encoded_origin_hash(:github)}" \
      "&team=#{team_id}"
  end

  def authenticate_github_response
    {
      response_type: "in_channel",
      text: "Please <#{slack_auth_url}|Sign in to GitHub>."
    }
  end

  def origin_hash(provider_name)
    {
      uri: "slack://channel?team=#{team_id}&id=#{channel_id}",
      team: team_id,
      token: id,
      provider: provider_name
    }
  end

  def encoded_origin_hash(provider_name = :heroku)
    data = JSON.dump(origin_hash(provider_name))
    Base64.encode64(data).split("\n").join("")
  end
end
