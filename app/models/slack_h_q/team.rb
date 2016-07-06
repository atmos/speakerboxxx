# DB record representing a slack team installation
class SlackHQ::Team < ApplicationRecord
  include AttributeEncryption

  has_many :users
  has_many :organizations, class_name: "GitHub::Organization"

  validates :bot_user_id, presence: true
  validates :enc_bot_token, presence: true

  def self.from_omniauth(omniauth_info)
    team = find_or_initialize_by(
      team_id: omniauth_info["info"]["team_id"]
    )

    if team.bot_token.blank?
      bot_info = omniauth_info["extra"] && omniauth_info["extra"]["bot_info"]
      bot_token = bot_info["bot_access_token"]
      team.bot_token = bot_token unless bot_token.blank?
      team.bot_user_id = bot_info["bot_user_id"]
    end

    team.save if team.new_record?
    team
  end

  def bot_token=(value)
    self[:enc_bot_token] = encrypt_value(value)
  end

  def bot_token
    decrypt_value(enc_bot_token)
  end

  def bot
    @bot ||= Slack::Web::Client.new(token: bot_token, logger: Rails.logger)
  end
end
