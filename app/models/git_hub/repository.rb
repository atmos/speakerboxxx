# DB record representing a configured GitHub repository
class GitHub::Repository < ApplicationRecord
  belongs_to :organization, required: true

  validates :name, presence: true
end
