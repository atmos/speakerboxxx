module GitHub::EventMessages
  # Class to generate Slack Messages based on a GitHub DeploymentStatus Webhook
  class DeploymentStatus
    attr_accessor :body
    def initialize(body)
      @body = JSON.parse(body)
    end

    def repo_name
      body["repository"]["name"]
    end

    def full_name
      body["repository"]["full_name"]
    end

    def branch
      if body["deployment"]["ref"] == body["deployment"]["sha"]
        short_sha
      else
        body["deployment"]["ref"]
      end
    end

    def target_url
      body["deployment_status"]["target_url"]
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
      body["deployment"]["sha"][0..7]
    end

    def author
      body["deployment"]["creator"]["login"]
    end

    def author_url
      "<https://github.com/#{author}|#{author}>"
    end

    def environment
      body["deployment"]["environment"]
    end

    def environment_url
      "<#{target_url}|#{environment}>"
    end

    def duration
      (Time.zone.parse(body["deployment_status"]["created_at"]) -
        Time.zone.parse(body["deployment"]["created_at"])).round
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

    def message_text
      case body["deployment_status"]["state"]
      when "pending"
        "#{author_url} is deploying #{repo_with_branch_url} to " \
          "#{environment_url}."
      when "success"
        "#{author_url}'s #{environment_url} deployment of " \
          "#{repo_with_branch_url} was successful. #{duration}s"
      else
        "#{author_url}'s #{environment_url} deployment of " \
          "#{repo_with_branch_url} failed. #{duration}s"
      end
    end

    def fallback_text
      case body["deployment_status"]["state"]
      when "pending"
        "#{author} is deploying #{repo_with_branch} to #{environment}."
      when "success"
        "#{author}'s #{environment} deployment of #{repo_with_branch}" \
         " was successful. #{duration}s"
      else
        "#{author}'s #{environment} deployment of #{repo_with_branch}" \
         " failed. #{duration}s"
      end
    end

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
  end
end
