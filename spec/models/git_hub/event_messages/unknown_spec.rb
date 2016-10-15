require "rails_helper"

RSpec.describe GitHub::EventMessages::Unknown, type: :model do
  it "handles unknown GitHub event to Slack Message" do
    data = decoded_fixture_data("webhooks/create-tag")

    handler = GitHub::EventMessages::Unknown.new(data, "team_add")

    response = handler.response
    expect(response[:channel]).to eql("#notifications")
    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#4785c0")
    expect(attachments.first[:text]).to eql("team_add :smiley:")
    expect(attachments.first[:fallback]).to eql("team_add :smiley:")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end
end
