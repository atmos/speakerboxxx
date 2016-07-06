require "rails_helper"

RSpec.describe GitHub::EventMessages::Push, type: :model do
  let(:team) { SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos) }
  let(:org) { team.organizations.create(name: "heroku", webhook_id: 42) }

  it "creates a push Slack Message" do
    data = fixture_data("webhooks/push-1-commit")

    handler = GitHub::EventMessages::Push.new(team, org, data)

    response = handler.response
    expect(response[:channel]).to eql("#general")
    expect(response[:text]).to match("1 new commit by Corey Donohoe")
    attachments = response[:attachments]
    expect(attachments.first[:fallback])
      .to eql("[speakerboxxx:master] 1 new commit by Corey Donohoe")
    expect(attachments.first[:color]).to eql("#4785c0")
    expect(attachments.first[:text])
      .to include("fetch body and write to disk in local dev - Corey Donohoe")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "uses plural form when multiple commits" do
    data = fixture_data("webhooks/push-2-commits")

    handler = GitHub::EventMessages::Push.new(team, org, data)

    response = handler.response
    expect(response[:channel]).to eql("#general")
    attachments = response[:attachments]
    expect(attachments.first[:fallback])
      .to eql("[speakerboxxx:master] 2 new commits by Corey Donohoe")
    expect(attachments.first[:color]).to eql("#4785c0")
    expect(response[:text]).to match("2 new commits by Corey Donohoe")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end
end
