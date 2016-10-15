module GitHub::EventMessages
  # Class to generate Slack Messages based on a GitHub DeploymentStatus Webhook
  class DeploymentStatus
    attr_accessor :body
    def initialize(body)
      @body = body
    end

    def repo_name
      body["repository"]["name"]
    end

    def full_name
      body["repository"]["full_name"]
    end

    def deployment
      body["deployment"]
    end

    def deployment_payload
      body["deployment"]["payload"]
    end

    def deployment_status
      body["deployment_status"]
    end

    def branch
      if deployment["ref"] == deployment["sha"]
        short_sha
      else
        deployment["ref"]
      end
    end

    def description
      deployment_status["description"]
    end

    def target_url
      deployment_status["target_url"]
    end

    def sha_url
      "https://github.com/#{full_name}/tree/#{short_sha}"
    end

    def repo_with_branch_url
      "<#{sha_url}|#{repo_with_branch}>"
    end

    def repo_with_branch
      "#{repo_name}/#{branch}"
    end

    def short_sha
      deployment["sha"][0..7]
    end

    def author
      deployment["creator"]["login"]
    end

    def author_url
      "<https://github.com/#{author}|#{author}>"
    end

    def environment
      result = deployment["environment"]
      if deployment_payload && deployment_payload["name"]
        result += "/#{deployment_payload['name']}"
      end
      result
    end

    def environment_url
      if target_url.nil?
        environment
      else
        "<#{target_url}|#{environment}>"
      end
    end

    def duration
      (Time.zone.parse(deployment_status["created_at"]) -
        Time.zone.parse(deployment["created_at"])).round
    end

    def message_color
      case body["deployment_status"]["state"]
      when "success"
        "#36a64f"
      when "pending"
        "#c0c0c0"
      else
        "#f00"
      end
    end

    def deployment_action
      case body["deployment_status"]["description"]
      when /Running release phase/
        "releasing"
      when /Release phase completed/
        "restarting"
      else
        "deploying"
      end
    end

    def message_text
      case body["deployment_status"]["state"]
      when "pending"
        "#{author_url} is #{deployment_action} #{repo_with_branch_url} to " \
          "#{environment_url}. #{duration}s"
      when "success"
        "#{author_url}'s #{environment_url} deployment of " \
          "#{repo_with_branch_url} was successful. #{duration}s"
      else
        failure_message_text
      end
    end

    def failure_message_text
      if target_url.nil?
        "#{author_url}'s #{environment_url} deployment of " \
          "#{repo_with_branch_url} failed. #{description} #{duration}s"
      else
        "#{author_url}'s #{environment_url} deployment of " \
          "#{repo_with_branch_url} failed. #{duration}s"
      end
    end

    # rubocop:disable Metrics/AbcSize
    def fallback_text
      case body["deployment_status"]["state"]
      when "pending"
        "#{author} is #{deployment_action} #{repo_with_branch} to " \
          "#{environment}. #{duration}s"
      when "success"
        "#{author}'s #{environment} deployment of #{repo_with_branch}" \
         " was successful. #{duration}s"
      else
        "#{author}'s #{environment} deployment of #{repo_with_branch}" \
         " failed. #{duration}s"
      end
    end
    # rubocop:enable Metrics/AbcSize

    def response
      return if environment =~ /pr-\d+$/
      {
        channel: "#notifications",
        attachments: [
          {
            text: message_text,
            fallback: fallback_text,
            color: message_color,
            mrkdwn_in: [:text, :pretext]
          }
        ]
      }
    end

    def chat_deployment?
      !chat_deployment_room.nil?
    end

    def chat_deployment_room
      deployment_payload &&
        deployment_payload["notify"] &&
        deployment_payload["notify"]["room"] &&
        deployment_payload["notify"]["room"].sub(/^#/, "")
    end
  end
end
