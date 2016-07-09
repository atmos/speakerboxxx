# DB record representing a configured GitHub organization
class GitHub::Organization < ApplicationRecord
  include AttributeEncryption

  belongs_to :team, class_name: "SlackHQ::Team", required: true
  has_many :repositories

  validates :name, presence: true
  validates :default_room, presence: true
  validates :enc_webhook_secret, presence: true

  before_validation :set_webhook_secret, on: :create

  def webhook_secret=(value)
    self[:enc_webhook_secret] = encrypt_value(value)
  end

  def webhook_secret
    decrypt_value(enc_webhook_secret)
  end

  def set_webhook_secret
    self.webhook_secret = SecureRandom.hex(24)
  end

  def default_room_for(name)
    return default_room if name.blank?
    repo = repositories.find { |r| r.name == name }
    if repo
      repo.default_room
    else
      default_room
    end
  end
end
