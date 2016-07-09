# Job to handle incoming GitHub webhooks
class WebhookJob < ApplicationJob
  queue_as :default

  # rubocop:disable Metrics/AbcSize
  def perform(*args)
    team_id = args.first.fetch(:team_id)
    team = SlackHQ::Team.find_by(team_id: team_id)

    org_name = args.first.fetch(:org_name)
    org = team.organizations.find_by(name: org_name)

    body         = args.first.fetch(:body)
    event_type   = args.first.fetch(:event_type)
    _delivery_id = args.first.fetch(:delivery_id)

    if Rails.env.development?
      File.open("tmp/#{event_type}-#{Time.now.to_i}.json", "w") do |fp|
        fp.puts body
      end
    end

    handler = GitHub::EventMessages.handler_for(event_type, JSON.load(body))
    if handler && handler.response
      response = handler.response
      response[:channel] = org.default_room_for(handler.repo_name)

      team.bot.chat_postMessage(response)
    end
  end
  # rubocop:enable Metrics/AbcSize
end
