# DB record representing a user in slack team installation
class SlackHQ::User < ApplicationRecord
  include AttributeEncryption
  include OctokitMethods

  belongs_to :team
  has_many :commands, class_name: "Command"

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
