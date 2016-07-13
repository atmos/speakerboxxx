# DB record representing a user in slack team installation
class SlackHQ::User < ApplicationRecord
  include AttributeEncryption
  include OctokitMethods

  belongs_to :team
  has_many :commands, class_name: "Command"

  def self.omniauth_user_data(omniauth_info)
    token = omniauth_info[:credentials][:token]
    response = slack_client.get("/api/users.identity?token=#{token}")

    JSON.load(response.body)
  end

  def self.from_omniauth(omniauth_info)
    body = omniauth_user_data(omniauth_info)
    team = SlackHQ::Team.find_or_initialize_by(
      team_id: body["team"]["id"]
    )
    team.save if team.new_record?

    user = team.users.find_or_initialize_by(
      slack_user_id: body["user"]["id"]
    )
    user.slack_user_name = body["user"]["name"]
    user.save
    user
  end

  def self.slack_client
    Faraday.new(url: "https://slack.com") do |connection|
      connection.headers["Content-Type"] = "application/json"
      connection.adapter Faraday.default_adapter
    end
  end

  def github_token=(value)
    self[:enc_github_token] = encrypt_value(value)
  end

  def github_token
    decrypt_value(enc_github_token)
  end

  def create_command_for(params)
    command = commands.create(
      channel_id: params[:channel_id],
      channel_name: params[:channel_name],
      command: params[:command],
      command_text: params[:text],
      response_url: params[:response_url],
      team_id: params[:team_id],
      team_domain: params[:team_domain]
    )
    CommandRunnerJob.perform_later(command_id: command.id)
    command
  end
end
