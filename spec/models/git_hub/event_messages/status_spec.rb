require "rails_helper"

RSpec.describe GitHub::EventMessages::Status, type: :model do
  it "returns nil if the status is pending" do
    data = decoded_fixture_data("webhooks/status-travis-pending")

    handler = GitHub::EventMessages::Status.new(data)
    expect(handler.response).to be_nil
  end

  it "returns a Slack message for travis if the status is success" do
    data = decoded_fixture_data("webhooks/status-travis-success")

    handler = GitHub::EventMessages::Status.new(data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to_not be_nil
    expect(attachments.first[:color]).to eql("#36a64f")
    expect(attachments.first[:text]).to eql("<https://github.com/atmos-org/speakerboxxx|speakerboxxx> build of <https://github.com/atmos-org/speakerboxxx/tree/master|master@7dcf6ad3> was successful. <https://travis-ci.com/atmos-org/speakerboxxx/builds/26768873|Details>") # rubocop:disable Metrics/LineLength

    fields = attachments.first[:fields]
    expect(fields).to be_nil

    expect(attachments.first[:footer]).to eql("Travis-CI on behalf of atmos")
    expect(attachments.first[:footer_icon]).to eql("https://cdn.travis-ci.com/images/logos/TravisCI-Mascot-grey-ab1429c891b31bb91d29cc0b5a9758de.png") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "returns a Slack message for travis if the status is failure" do
    data = decoded_fixture_data("webhooks/status-travis-failure")

    handler = GitHub::EventMessages::Status.new(data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to_not be_nil
    expect(attachments.first[:color]).to eql("#f00")
    expect(attachments.first[:text]).to eql("<https://github.com/atmos-org/speakerboxxx|speakerboxxx> build of <https://github.com/atmos-org/speakerboxxx/tree/add-pull-requests|add-pull-requests@89bfabcc> failed. <https://travis-ci.com/atmos-org/speakerboxxx/builds/26834904|Details>") # rubocop:disable Metrics/LineLength

    fields = attachments.first[:fields]
    expect(fields).to be_nil

    expect(attachments.first[:footer]).to eql("Travis-CI on behalf of atmos")
    expect(attachments.first[:footer_icon]).to eql("https://cdn.travis-ci.com/images/logos/TravisCI-Mascot-grey-ab1429c891b31bb91d29cc0b5a9758de.png") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "returns a Slack message for circleci if the status is success" do
    data = decoded_fixture_data("webhooks/status-circle-success")

    handler = GitHub::EventMessages::Status.new(data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")

    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to_not be_nil
    expect(attachments.first[:color]).to eql("#36a64f")
    expect(attachments.first[:text]).to eql("<https://github.com/atmos-org/speakerboxxx|speakerboxxx> build of <https://github.com/atmos-org/speakerboxxx/tree/master|master@a2df354c> was successful. <https://circleci.com/gh/atmos-org/speakerboxxx/1|Details>") # rubocop:disable Metrics/LineLength

    fields = attachments.first[:fields]
    expect(fields).to be_nil

    expect(attachments.first[:footer]).to eql("circle-ci")
    expect(attachments.first[:footer_icon]).to eql("https://cloud.githubusercontent.com/assets/38/16295346/2b121e26-38db-11e6-9c4f-ee905519fdf3.png") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "returns a Slack message for circle if the status is failure" do
    data = decoded_fixture_data("webhooks/status-circle-failure")

    handler = GitHub::EventMessages::Status.new(data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to_not be_nil
    expect(attachments.first[:color]).to eql("#f00")
    expect(attachments.first[:text]).to eql("<https://github.com/atmos-org/speakerboxxx|speakerboxxx> build of <https://github.com/atmos-org/speakerboxxx/tree/master|master@a2df354c> failed. <https://circleci.com/gh/atmos-org/speakerboxxx/1|Details>") # rubocop:disable Metrics/LineLength

    fields = attachments.first[:fields]
    expect(fields).to be_nil

    expect(attachments.first[:footer]).to eql("circle-ci")
    expect(attachments.first[:footer_icon]).to eql("https://cloud.githubusercontent.com/assets/38/16295346/2b121e26-38db-11e6-9c4f-ee905519fdf3.png") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "returns a Slack message for changeling if the status is successful" do
    data = decoded_fixture_data("webhooks/status-changeling-success")

    handler = GitHub::EventMessages::Status.new(data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to_not be_nil
    expect(attachments.first[:color]).to eql("#36a64f")
    expect(attachments.first[:text]).to eql("<https://github.com/atmos-org/speakerboxxx|speakerboxxx> build of <https://github.com/atmos-org/speakerboxxx/tree/endpoint-events|endpoint-events@46afb288> was successful. <https://changeling.heroku.tools/multipasses/4689e051-468a-4c09-8cdc-2958e1558f01|Details>") # rubocop:disable Metrics/LineLength

    fields = attachments.first[:fields]
    expect(fields).to be_nil

    expect(attachments.first[:footer]).to eql("Changeling: All requirements completed. Reviewed by dmcinnes.") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:footer_icon]).to eql("https://cloud.githubusercontent.com/assets/38/16531791/ebc00ff4-3f82-11e6-919b-693a5cf9183a.png") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end

  it "returns a Slack message for fork repos without branch references" do
    data = decoded_fixture_data("webhooks/status-changeling-success-fork")

    handler = GitHub::EventMessages::Status.new(data)
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    expect(response[:text]).to be_nil
    attachments = response[:attachments]
    expect(attachments.first[:fallback]).to_not be_nil
    expect(attachments.first[:color]).to eql("#36a64f")
    expect(attachments.first[:text]).to eql("<https://github.com/atmos-org/speakerboxxx|speakerboxxx> build of <https://github.com/atmos-org/speakerboxxx/tree/46afb288|46afb288> was successful. <https://changeling.heroku.tools/multipasses/4689e051-468a-4c09-8cdc-2958e1558f01|Details>") # rubocop:disable Metrics/LineLength

    fields = attachments.first[:fields]
    expect(fields).to be_nil

    expect(attachments.first[:footer]).to eql("Changeling: All requirements completed. Reviewed by dmcinnes.") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:footer_icon]).to eql("https://cloud.githubusercontent.com/assets/38/16531791/ebc00ff4-3f82-11e6-919b-693a5cf9183a.png") # rubocop:disable Metrics/LineLength
    expect(attachments.first[:mrkdwn_in]).to eql([:text, :pretext])
  end
end
