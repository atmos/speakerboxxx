# Job to handle incoming GitHub webhooks
class WebhookJob < ApplicationJob
  queue_as :default

  def suppressed_actions
    %w{commit_comment create deployment fork issues issue_comment \
       member membership pull_request_review_comment repository team_add watch}
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def perform(*args)
    team_id = args.first.fetch(:team_id)
    team = SlackHQ::Team.find_by(team_id: team_id)

    org_name = args.first.fetch(:org_name)
    org = team.organizations.find_by(name: org_name)

    body        = args.first.fetch(:body)
    event_type  = args.first.fetch(:event_type)
    delivery_id = args.first.fetch(:delivery_id)

    if Rails.env.development?
      File.open("tmp/#{event_type}-#{Time.now.to_i}.json", "w") do |fp|
        fp.puts body
      end
    end

    case event_type
    when "delete"
      handler = GitHub::EventMessages::Delete.new(team, org, body)
      team.bot.chat_postMessage(handler.response)
    when "ping"
      handler = GitHub::EventMessages::Ping.new(team, org, body)
      team.bot.chat_postMessage(handler.response)
    when "push"
      handler = GitHub::EventMessages::Push.new(team, org, body)
      team.bot.chat_postMessage(handler.response) if handler.response
    when "pull_request"
      handler = GitHub::EventMessages::PullRequest.new(team, org, body)
      team.bot.chat_postMessage(handler.response) if handler.response
    when "status"
      handler = GitHub::EventMessages::Status.new(team, org, body)
      team.bot.chat_postMessage(handler.response) if handler.response
    when "deployment_status"
      handler = GitHub::EventMessages::DeploymentStatus.new(team, org, body)
      team.bot.chat_postMessage(handler.response) if handler.response
    when *suppressed_actions
      nil
    else
      team.bot.chat_postMessage(channel: org.default_room,
                                text: "#{event_type} :smiley:",
                                as_user: false)
    end
    Rails.logger.info "#{delivery_id} : #{team.team_id} : #{org.default_room}"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
end
