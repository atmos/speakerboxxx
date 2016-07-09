require "rails_helper"

RSpec.describe GitHub::EventMessages::Ping, type: :model do
  it "creates a push Slack Message" do
    team = SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos)
    expect(team).to be_valid

    org = team.organizations.create(name: "heroku", webhook_id: 42)
    expect(org).to be_valid

    data = decoded_fixture_data("webhooks/ping")

    handler = GitHub::EventMessages::Ping.new(data)

    response = handler.response
    expect(response[:channel]).to eql("#notifications")
    expect(response[:text]).to be_nil

    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#4785c0")
    expect(attachments.first[:text]).to be_nil
    expect(attachments.first[:title]).to eql("Webhooks enabled: :bell:")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])

    fields = attachments.first[:fields]
    org_cell = fields.first
    expect(org_cell[:title]).to eql("Organization")
    expect(org_cell[:value]).to eql("<https://github.com/organizations/atmos-org/settings|atmos-org>") # rubocop:disable Metrics/LineLength

    admin_cell = fields.second
    expect(admin_cell[:title]).to eql("Admin")

    expect(admin_cell[:value]).to eql("<https://github.com/organizations/atmos-org/settings/hooks/8830165|On GitHub>") # rubocop:disable Metrics/LineLength

    status_cell = fields.third
    expect(status_cell[:title]).to eql("Status")
    expect(status_cell[:value]).to eql("Enabled")

    zen_cell = fields.fourth
    expect(zen_cell[:title]).to eql("Zen")
    expect(zen_cell[:value]).to eql("It's not fully shipped until it's fast.")
  end
end
