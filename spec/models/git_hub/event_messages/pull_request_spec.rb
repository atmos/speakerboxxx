require "rails_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe GitHub::EventMessages::PullRequest, type: :model do
  let(:org) { team.organizations.create(name: "heroku", webhook_id: 42) }
  let(:team) { SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos) }

  it "returns a Slack message for pull request opened" do
    data = fixture_data("webhooks/pull_request-opened")

    handler = GitHub::EventMessages::PullRequest.new(team, org, data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#general")
    expect(response[:text])
      .to eql("[atmos-org/speakerboxxx] Pull request opened by <https://github.com/atmos|atmos>")
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to eql("[atmos-org/speakerboxxx] Pull request #1 opened by atmos")
    expect(attachments.first[:color]).to eql("#36a64f")
    expect(attachments.first[:title]).to eql("#1 Add pull requests")
    expect(attachments.first[:title_link])
      .to eql("https://github.com/atmos-org/speakerboxxx/pull/1")
    expect(attachments.first[:text]).to eql("This adds pull requests")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "returns the right Slack message when pull request merged" do
    data = fixture_data("webhooks/pull_request-merged")

    handler = GitHub::EventMessages::PullRequest.new(team, org, data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#general")
    expect(response[:text])
      .to eql("[atmos-org/speakerboxxx] Pull request merged by <https://github.com/atmos|atmos>")
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to eql("[atmos-org/speakerboxxx] Pull request #1 merged by atmos")
    expect(attachments.first[:color]).to eql("#6e5692")
    expect(attachments.first[:title]).to eql("#1 Add pull requests")
    expect(attachments.first[:title_link])
      .to eql("https://github.com/atmos-org/speakerboxxx/pull/1")
    expect(attachments.first[:text]).to eql("This adds pull requests")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end
end
# rubocop:enable Metrics/LineLength
