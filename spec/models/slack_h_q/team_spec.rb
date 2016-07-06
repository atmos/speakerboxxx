require "rails_helper"

RSpec.describe SlackHQ::Team, type: :model do
  it "creates a user successfully" do
    team = SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos)
    expect(team).to be_valid
  end
end
