require "rails_helper"

RSpec.describe "Speakerboxxx POST /buttons", type: :request do
  def default_params(options = {})
    data = decoded_fixture_data("slack.com/button-confirm-payload")
    if options[:token]
      data[:token] = options[:token]
    end
    {
      payload: data.to_json
    }
  end

  it "403s on bad command tokens POST to /buttons" do
    post "/buttons", params: default_params(token: "xoxo-abcdefg")
    expect(status).to eql(403)
    data = JSON.load(response.body)
    expect(data).to eql({})
  end

  it "201s on unauthenticated POST to /buttons" do
    post "/buttons", params: default_params
    expect(status).to eql(201)
    data = JSON.load(response.body)
    expect(data["text"]).to include("Sign in to GitHub")
  end

  it "200s on authenticated POST to /buttons" do
    create_atmos
    user = SlackHQ::User.find_by(slack_user_id: "U123YG08X")
    user.github_login = "atmos"
    user.github_token = SecureRandom.hex(24)
    user.save

    post "/buttons", params: default_params
    expect(status).to eql(200)
    data = JSON.load(response.body)
    expect(data).to eql({})
  end
end
