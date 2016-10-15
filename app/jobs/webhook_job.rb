# Job to handle incoming GitHub webhooks
class WebhookJob < ApplicationJob
  queue_as :default

  def self.redis
    @redis ||= Redis.new
  end

  def redis
    self.class.redis
  end

  def cache_ts!(key, ts)
    redis.set(key, ts, ex: 1.hour)
  end

  def cache_ts(key)
    redis.get(key)
  end

  # rubocop:disable Metrics/AbcSize
  def post_back(team, response, event_type, body)
    case event_type
    when "deployment_status"
      cache_key = "#{team.id}-#{response[:channel]}-" \
                  "#{event_type}-#{body['deployment']['id']}"

      Rails.logger.info at: "webhook-deployment-status", key: cache_key
      if cache_ts(cache_key)
        team.bot.chat_update(response.merge(ts: cache_ts(cache_key)))
        team.bot.chat_postMessage(
          response.merge(thread_ts: cache_ts(cache_key))
        )
      else
        message = team.bot.chat_postMessage(response)
        team.bot.chat_postMessage(
          response.merge(thread_ts: message.ts)
        )
        cache_ts!(cache_key, message.ts)
      end
    else
      team.bot.chat_postMessage(response)
    end
  rescue Slack::Web::Api::Error
    Rails.logger.info "Unable to route #{team.team_id}: #{response.inspect}"
    nil
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def perform(*args)
    team_id = args.first.fetch(:team_id)
    team = SlackHQ::Team.find_by(team_id: team_id)

    return if team.nil?

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

    handler = GitHub::EventMessages.handler_for(event_type, JSON.parse(body))
    return unless handler && handler.response
    response = handler.response
    channel  = org.default_room_for(handler.repo_name)

    response[:channel] = channel

    post_back(team, response, event_type, JSON.parse(body))

    return unless event_type == "deployment_status" && handler.chat_deployment?
    chat_channel = "##{handler.chat_deployment_room}"
    return unless chat_channel != channel && chat_channel != "#privategroup"
    response[:channel] = chat_channel
    post_back(team, response, event_type, JSON.parse(body))
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize
end
