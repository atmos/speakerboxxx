require "rails_helper"

RSpec.describe GitHub::Organization, type: :model do
  it "creates a user successfully" do
    team = SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos)
    expect(team).to be_valid

    org = team.organizations.create(name: "heroku", webhook_id: 42)
    expect(org).to be_valid
  end
end
