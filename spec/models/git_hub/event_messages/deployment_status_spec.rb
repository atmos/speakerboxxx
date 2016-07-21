require "rails_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe GitHub::EventMessages::DeploymentStatus, type: :model do
  it "returns a started message the state is pending" do
    data = decoded_fixture_data("webhooks/deployment_status-pending")

    handler = GitHub::EventMessages::DeploymentStatus.new(data)
    expect(handler).to_not be_chat_deployment
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#c0c0c0")
    expect(attachments.first[:text])
      .to eql("<https://github.com/atmos|atmos> is deploying <https://github.com/atmos-org/speakerboxxx/tree/923821e5|speakerboxxx/master> to <https://dashboard.heroku.com/apps/speakerboxxx-production/activity/builds/96d42bc6-4461-49d2-be08-0208531728c4|production>.")
    expect(attachments.first[:fallback])
      .to eql("atmos is deploying speakerboxxx/master to production.")
  end

  it "returns a Slack message if the state is success" do
    data = decoded_fixture_data("webhooks/deployment_status-success")

    handler = GitHub::EventMessages::DeploymentStatus.new(data)
    expect(handler).to_not be_chat_deployment
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#36a64f")
    expect(attachments.first[:text])
      .to eql("<https://github.com/atmos|atmos>'s <https://dashboard.heroku.com/apps/speakerboxxx-production/activity/builds/96d42bc6-4461-49d2-be08-0208531728c4|production> deployment of <https://github.com/atmos-org/speakerboxxx/tree/923821e5|speakerboxxx/master> was successful. 31s")
    expect(attachments.first[:fallback])
      .to eql("atmos's production deployment of speakerboxxx/master was successful. 31s")
  end

  it "returns a Slack message if the status is failure" do
    data = decoded_fixture_data("webhooks/deployment_status-failure")

    handler = GitHub::EventMessages::DeploymentStatus.new(data)
    expect(handler).to_not be_chat_deployment
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#f00")
    expect(attachments.first[:text])
      .to eql("<https://github.com/atmos|atmos>'s <https://dashboard.heroku.com/apps/speakerboxxx-production/activity/builds/96d42bc6-4461-49d2-be08-0208531728c4|production> deployment of <https://github.com/atmos-org/speakerboxxx/tree/923821e5|speakerboxxx/master> failed. 31s")
    expect(attachments.first[:fallback])
      .to eql("atmos's production deployment of speakerboxxx/master failed. 31s")
  end

  it "returns a Slack message if they deployed ref is a full sha" do
    data = decoded_fixture_data("webhooks/deployment_status-full-ref")

    handler = GitHub::EventMessages::DeploymentStatus.new(data)
    expect(handler).to_not be_chat_deployment
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#f00")
    expect(attachments.first[:text])
      .to eql("<https://github.com/atmos|atmos>'s <https://dashboard.heroku.com/apps/speakerboxxx-production/activity/builds/96d42bc6-4461-49d2-be08-0208531728c4|production> deployment of <https://github.com/atmos-org/speakerboxxx/tree/923821e5|speakerboxxx/923821e5> failed. 31s")
    expect(attachments.first[:fallback])
      .to eql("atmos's production deployment of speakerboxxx/923821e5 failed. 31s")
  end

  it "can identify and route chat initiated deployments" do
    data = decoded_fixture_data("webhooks/deployment_status-pending-chat")

    handler = GitHub::EventMessages::DeploymentStatus.new(data)
    expect(handler).to be_chat_deployment
    expect(handler.chat_deployment_room).to eql("general")
    response = handler.response
    expect(response).to_not be_nil
    expect(response[:channel]).to eql("#notifications")
    attachments = response[:attachments]
    expect(attachments.first[:color]).to eql("#c0c0c0")
    expect(attachments.first[:text])
      .to eql("<https://github.com/atmos|atmos> is deploying <https://github.com/atmos-org/speakerboxxx/tree/923821e5|speakerboxxx/master> to <https://dashboard.heroku.com/apps/speakerboxxx-production/activity/builds/96d42bc6-4461-49d2-be08-0208531728c4|production>.")
    expect(attachments.first[:fallback])
      .to eql("atmos is deploying speakerboxxx/master to production.")
  end
end
# rubocop:enable Metrics/LineLength
