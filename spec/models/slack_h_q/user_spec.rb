require "rails_helper"

RSpec.describe SlackHQ::User, type: :model do
  it "creates a user successfully" do
    team = SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos)
    user = team.users.find_or_initialize_by(slack_user_id: "U0YJYFQ4E")
    expect(user).to be_valid
  end
end
