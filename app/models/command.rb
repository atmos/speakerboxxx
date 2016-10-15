# A command a Slack User issued
class Command < ApplicationRecord
  include CommandOnboarding

  belongs_to :user, class_name: "SlackHQ::User", required: false

  before_validation :extract_cli_args, on: :create

  def self.from_params(params)
    create(
      channel_id: params[:channel_id],
      channel_name: params[:channel_name],
      command: params[:command],
      command_text: params[:text],
      response_url: params[:response_url],
      slack_user_id: params[:user_id],
      team_id: params[:team_id],
      team_domain: params[:team_domain]
    )
  end

  def run
    handler.run
    postback_message(handler.response)
  end

  def handler
    @handler ||= case task
                 when "org"
                   Commands::Organization.new(self)
                 when "route"
                   Commands::Route.new(self)
                 else
                   Commands::Help.new(self)
                 end
  end

  def description
    if application
      "Running(#{id}): '#{task}:#{subtask}' for #{application}..."
    else
      "Running(#{id}): '#{task}:#{subtask}'..."
    end
  end

  def notify_user_of_success!
    user = User.find_by(slack_user_id: slack_user_id)
    return unless user
    name = "<@#{user.slack_user_id}|#{user.slack_user_name}>"
    postback_message(text_response("#{name} you're all set. :tada:"))
  end

  def default_response
    { response_type: "in_channel" }
  end

  def text_response(text)
    { text: text, response_type: "in_channel" }
  end

  def postback_message(message)
    response = client.post do |request|
      request.url callback_uri.path
      request.body = message.to_json
      request.headers["Content-Type"] = "application/json"
    end

    Rails.logger.info response.body
  rescue StandardError => e
    Rails.logger.info "Unable to post back to slack: '#{e.inspect}'"
  end

  def slack_team
    @slack_team ||= SlackHQ::Team.find_by(team_id: team_id)
  end

  private

  def callback_uri
    @callback_uri ||= ::Addressable::URI.parse(response_url)
  end

  def client
    @client ||= Faraday.new(url: "https://hooks.slack.com")
  end

  def extract_cli_args
    self.subtask = "default"

    match = command_text.match(/-a ([-_\.0-9a-z]+)/)
    self.application = match[1] if match

    match = command_text.match(/^([-_\.0-9a-z]+)(?:\:([^\s]+))/)
    if match
      self.task    = match[1]
      self.subtask = match[2]
    end

    match = command_text.match(/^([-_\.0-9a-z]+)\s*/)
    self.task = match[1] if match
  end
end
