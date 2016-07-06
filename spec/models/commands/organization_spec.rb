require "rails_helper"

RSpec.describe Commands::Organization, type: :model do
  let(:user) { create_atmos }
  let(:org) { team.organizations.create(name: "atmos-org", webhook_id: 1) }
  let(:team) { SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos) }

  let(:webhook_url) do
    "https://speakerboxxx-test.atmos.org/webhooks/T123YG08V/github/atmos-org"
  end

  it "org:info responds with :+1: if configured properly" do
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org",
                      github_fixture_data("orgs/atmos-org/index"))
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org/hooks",
                      github_fixture_data("orgs/atmos-org/hooks/configured"))

    command_params = command_params_for("org:info atmos-org")
    command = user.create_command_for(command_params)

    handler = command.handler
    expect(handler.organization_name).to eql("atmos-org")
    expect(handler.organization_webhook_url).to eql(webhook_url)

    handler.run

    expect(handler.org_hooks?).to be true
    response = {
      text: "atmos-org is good to go :+1:.",
      response_type: "in_channel"
    }
    expect(handler.response).to eql(response)
  end

  it "org:info responds with a message if unconfigured" do
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org",
                      github_fixture_data("orgs/atmos-org/index"))
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org/hooks",
                      github_fixture_data("orgs/atmos-org/hooks/empty"))

    command_params = command_params_for("org:info atmos-org")
    command = user.create_command_for(command_params)

    handler = command.handler
    expect(handler.organization_name).to eql("atmos-org")
    expect(handler.organization_webhook_url).to eql(webhook_url)

    handler.run

    expect(handler.org_hooks?).to be false
    response = {
      text: "atmos-org isn't configured.",
      response_type: "in_channel"
    }
    expect(handler.response).to eql(response)
  end

  it "org:enable responds with a message saying it successfully configured" do
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org",
                      github_fixture_data("orgs/atmos-org/index"))
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org/hooks",
                      github_fixture_data("orgs/atmos-org/hooks/empty"))

    stub_json_request(:post, "https://api.github.com/orgs/atmos-org/hooks",
                      github_fixture_data("orgs/atmos-org/hooks/create"))

    command_params = command_params_for("org:enable atmos-org")
    command = user.create_command_for(command_params)

    handler = command.handler
    expect(handler.organization_name).to eql("atmos-org")
    expect(handler.organization_webhook_url).to eql(webhook_url)

    handler.run

    response = {
      text: "atmos-org webhooks are enabled. <|View>",
      response_type: "in_channel"
    }
    expect(handler.response).to eql(response)
  end

  it "org:disable responds with a message saying it successfully disabled" do
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org",
                      github_fixture_data("orgs/atmos-org/index"))
    stub_json_request(:get, "https://api.github.com/orgs/atmos-org/hooks",
                      github_fixture_data("orgs/atmos-org/hooks/configured"))

    github_hook_url = "https://api.github.com/orgs/atmos-org/hooks/7579642"
    stub_json_request(:delete, github_hook_url, "{}", 204)

    command_params = command_params_for("org:disable atmos-org")
    command = user.create_command_for(command_params)

    handler = command.handler
    expect(handler.organization_name).to eql("atmos-org")
    expect(handler.organization_webhook_url).to eql(webhook_url)

    handler.run

    response = {
      text: "atmos-org webhooks are disabled.",
      response_type: "in_channel"
    }
    expect(handler.response).to eql(response)
  end
end
