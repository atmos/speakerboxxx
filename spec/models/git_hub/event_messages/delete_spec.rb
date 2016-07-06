require "rails_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe GitHub::EventMessages::Delete, type: :model do
  it "creates a push Slack Message" do
    team = SlackHQ::Team.from_omniauth(slack_omniauth_hash_for_atmos)
    expect(team).to be_valid

    org = team.organizations.create(name: "heroku", webhook_id: 42)
    expect(org).to be_valid

    data = fixture_data("webhooks/delete")

    handler = GitHub::EventMessages::Delete.new(team, org, data)

    response = handler.response
    expect(response[:channel]).to eql("#general")
    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#4785c0")
    expect(attachments.first[:text])
      .to eql("<https://github.com/atmos-org/speakerboxxx|[speakerboxxx]> The branch \"add-pull-requests\"  was deleted by atmos.")
    expect(attachments.first[:fallback])
      .to eql("[atmos-org/speakerboxxx] The branch \"add-pull-requests\" was deleted by atmos.")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end
end
# rubocop:enable Metrics/LineLength
