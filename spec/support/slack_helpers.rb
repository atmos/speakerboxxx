# rubocop:disable Metrics/LineLength
module SlackHelpers
  def command_params_for(text)
    {
      channel_id: "C99NNAY74",
      channel_name: "#spam",
      command: "/gh-notify",
      response_url: "https://hooks.slack.com/commands/T123YG08V/2459573/mfZPdDq",
      team_id: "T123YG08V",
      team_domain: "atmos-org",
      text: text
    }
  end
end
