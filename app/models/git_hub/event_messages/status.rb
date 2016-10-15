module GitHub::EventMessages
  # Class to generate Slack Messages based on a GitHub Status Webhook
  class Status
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

    def branch
      @branch ||= branch!
    end

    def branch!
      if body["branches"].any?
        body["branches"].first["name"]
      else
        short_sha
      end
    end

    def branch_ref
      if short_sha == branch
        short_sha
      else
        branch
      end
    end

    def target_url
      body["target_url"]
    end

    def repo_url
      "https://github.com/#{full_name}"
    end

    def branch_url
      "#{repo_url}/tree/#{branch}"
    end

    def sha_url
      "#{repo_url}/tree/#{short_sha}"
    end

    def title
      "<#{branch_url}|[#{repo_name}:#{branch}]>"
    end

    def short_sha
      body["sha"][0..7]
    end

    def actor
      commit["committer"]["login"]
    rescue StandardError
      "Unknown"
    end

    def commit
      body["commit"]
    end

    def state_description
      case body["state"]
      when "success"
        "was successful"
      else
        "failed"
      end
    end

    def message_color
      body["state"] == "success" ? "#36a64f" : "#f00"
    end

    def actor_description
      case actor
      when "web-flow"
        ""
      else
        " for #{actor}"
      end
    end

    def changeling_description
      body["description"].gsub("All requirements completed. ", "")
    end

    def footer_text
      case body["context"]
      when "ci/circleci"
        "circle-ci built #{short_sha}#{actor_description}"
      when "continuous-integration/travis-ci/push"
        "Travis-CI built #{short_sha}#{actor_description}"
      when "heroku/compliance"
        "Changeling: #{changeling_description}"
      when "continuous-integration/heroku"
        "Heroku-CI built #{short_sha}#{actor_description}"
      else
        "Unknown"
      end
    end

    # rubocop:disable Metrics/LineLength
    def footer_icon
      case body["context"]
      when "ci/circleci"
        "https://cloud.githubusercontent.com/assets/38/16295346/2b121e26-38db-11e6-9c4f-ee905519fdf3.png"
      when "continuous-integration/travis-ci/push"
        "https://cloud.githubusercontent.com/assets/483012/22075201/56ed65da-ddab-11e6-954c-2636206bf6a4.png"
      when "heroku/compliance", "continuous-integration/heroku"
        "https://cloud.githubusercontent.com/assets/38/16531791/ebc00ff4-3f82-11e6-919b-693a5cf9183a.png"
      when "vulnerabilities/gems"
        "https://cloud.githubusercontent.com/assets/38/16547100/e23b670e-4116-11e6-8b38-bac1b4c853f0.jpg"
      end
    end
    # rubocop:enable Metrics/LineLength

    def suppressed_contexts
      %w{codeclimate continuous-integration/travis-ci/pr vulnerabilities/gems}
    end

    def attachment_text
      "<#{repo_url}|#{repo_name}> build of <#{branch_url}|#{branch_ref}> " \
        "#{state_description}. <#{target_url}|Details>"
    end

    def fallback_text
      "#{repo_name} build of #{branch} was #{state_description}"
    end

    def response
      return if body["state"] == "pending"
      return if suppressed_contexts.include?(body["context"])
      {
        channel: "#notifications",
        attachments: [
          {
            fallback: fallback_text,
            color: message_color,
            text: attachment_text,
            footer: footer_text,
            footer_icon: footer_icon,
            mrkdwn_in: [:text, :pretext]
          }
        ]
      }
    end
  end
end
