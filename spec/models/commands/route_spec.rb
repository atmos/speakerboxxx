require "rails_helper"

RSpec.describe Commands::Route, type: :model do
  let(:user) { create_atmos }
  let(:org) { team.organizations.create(name: "atmos-org", webhook_id: 1) }
  let(:team) { SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos) }

  before do
    expect(org).to be_valid
  end

  it "route:info responds with :+1: if configured properly" do
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org",
                      github_fixture_data("orgs/atmos-org/index"))
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org/hooks",
                      github_fixture_data("orgs/atmos-org/hooks/configured"))

    command_params = command_params_for("route:info atmos-org/speakerboxxx")
    command = user.create_command_for(command_params)

    handler = command.handler
    expect(handler.organization_name).to eql("atmos-org")
    expect(handler.repository_name).to eql("speakerboxxx")

    handler.run

    expect(handler.org_hooks?).to be true
    response = {
      text: "atmos-org/speakerboxxx is configured and routing to #general.",
      response_type: "in_channel"
    }
    expect(handler.response).to eql(response)
  end

  it "route responds with :+1: if configured properly" do
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org",
                      github_fixture_data("orgs/atmos-org/index"))
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org/hooks",
                      github_fixture_data("orgs/atmos-org/hooks/configured"))

    command_string = "route atmos-org/speakerboxxx #notifications"
    command_params = command_params_for(command_string)
    command = user.create_command_for(command_params)

    handler = command.handler
    expect(handler.organization_name).to eql("atmos-org")
    expect(handler.repository_name).to eql("speakerboxxx")
    expect(handler.room_name).to eql("#notifications")

    expect do
      handler.run

      expect(handler.org_hooks?).to be true
      response = {
        text: "atmos-org/speakerboxxx is configured and routing to " \
              "#notifications.",
        response_type: "in_channel"
      }
      expect(handler.response).to eql(response)
    end.to change { GitHub::Repository.count }.from(0).to(1)
  end
end
