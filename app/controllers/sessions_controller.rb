# Session controller for authenticating users with GitHub/Slack
class SessionsController < ApplicationController
  include SessionsHelper

  def create_github
    user = SlackHQ::User.find(session[:user_id])
    user.github_login = omniauth_info["info"]["login"]
    user.github_token = omniauth_info["credentials"]["token"]

    user.save
    redirect_to "/"
  rescue ActiveRecord::RecordNotFound
    redirect_to "/auth/slack?origin=#{omniauth_origin}"
  end

  def create_slack
    user = SlackHQ::User.from_omniauth(omniauth_info)

    session[:user_id] = user.id
    redirect_to "/auth/github"
  end

  def install_slack
    team = SlackHQ::Team.from_omniauth(omniauth_info)

    user = team.users.find_or_initialize_by(
      slack_user_id: omniauth_info_user_id
    )

    user.slack_user_name = omniauth_info["info"]["user"]
    user.save

    session[:user_id] = user.id
    redirect_to "/auth/github"
  end

  def destroy
    session.clear
    redirect_to root_url, notice: "Signed out!"
  end
end
