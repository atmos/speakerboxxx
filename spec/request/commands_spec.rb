require "rails_helper"

RSpec.describe "Speakerboxxx POST /commands", type: :request do
  def default_params(options = {})
    command_params_for("").merge(
      token: "secret-slack-token",
      user_id: "U123YG08X",
      user_name: "atmos"
    ).merge(options)
  end

  it "403s on a bad token POST to /commands" do
    post "/commands", params: default_params(token: "bad-slack-token")
    expect(status).to eql(403)
  end

  it "201s on POST to /commands" do
    post "/commands", params: default_params(text: "help")
    expect(status).to eql(201)
    response_body = JSON.parse(body)
    expect(response_body["text"]).to include("Sign in to GitHub")
  end
end
