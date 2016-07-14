require "rails_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe GitHub::EventMessages::Create, type: :model do
  it "creates a tagged Slack Message" do
    data = decoded_fixture_data("webhooks/create-tag")

    handler = GitHub::EventMessages::Create.new(data)

    response = handler.response
    expect(response[:channel]).to eql("#notifications")
    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#4785c0")
    expect(attachments.first[:text])
      .to eql("<https://github.com/atmos-org/speakerboxxx|[speakerboxxx]> atmos tagged <https://github.com/atmos-org/speakerboxxx/tree/testing|testing>.")
    expect(attachments.first[:fallback])
      .to eql("[atmos-org/speakerboxxx] atmos tagged \"testing\".")
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "discards branch creation" do
    data = decoded_fixture_data("webhooks/create-branch")

    handler = GitHub::EventMessages::Create.new(data)

    response = handler.response
    expect(response).to be_nil
  end
end
# rubocop:enable Metrics/LineLength
