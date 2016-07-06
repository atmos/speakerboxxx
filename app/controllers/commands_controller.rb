# HTTP Endpoint for handling incoming slash commands
class CommandsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    if slack_token_valid?
      if current_user && current_user.github_token
        command = current_user.create_command_for(params)
        render json: command.default_response.to_json, status: 201
      else
        command = Command.from_params(params)
        render json: command.authenticate_github_response, status: 201
      end
    else
      render json: {}, status: 403
    end
  end

  private

  def current_user
    @current_user ||= SlackHQ::User.find_by(slack_user_id: params[:user_id])
  end

  def slack_token
    ENV["SLACK_SLASH_COMMAND_TOKEN"]
  end

  def slack_token_valid?
    ActiveSupport::SecurityUtils.secure_compare(params[:token], slack_token)
  end
end
