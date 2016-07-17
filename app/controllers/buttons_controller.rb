# HTTP Endpoint for handling incoming interactive messages
class ButtonsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    params.permit!
    if slack_token_valid?
      if current_user && current_user.github_token
        render json: {}, status: 200
      else
        command = Command.from_params(payload)
        render json: command.authenticate_github_response, status: :created
      end
    else
      render json: {}, status: 403
    end
  end

  private

  def current_user
    @current_user ||= SlackHQ::User.find_by(slack_user_id: payload[:user][:id])
  end

  def slack_token
    ENV["SLACK_SLASH_COMMAND_TOKEN"]
  end

  def payload
    @payload ||= payload!
  end

  def payload!
    ActiveSupport::HashWithIndifferentAccess.new(JSON.load(params[:payload]))
  end

  def slack_token_valid?
    ActiveSupport::SecurityUtils.secure_compare(payload[:token], slack_token)
  end
end
