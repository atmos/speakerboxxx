module GitHub::EventMessages
  # Class to generate Slack Messages based on a GitHub PullRequest Webhook
  class PullRequest
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
      @branch ||= body["branches"].first
    end

    def branch_name
      body["pull_request"]["head"]["ref"]
    end

    def number
      body["number"]
    end

    def branch_url
      "https://github.com/#{full_name}/tree/#{branch_name}"
    end

    def sha_url
      "https://github.com/#{full_name}/tree/#{short_sha}"
    end

    def title
      "[#{full_name}] Pull request #{action} by #{author_link}"
    end

    def fallback_title
      "[#{full_name}] Pull request ##{number} #{action} by #{author}"
    end

    def action
      case body["pull_request"]["merged"]
      when true
        "merged"
      else
        body["action"]
      end
    end

    def short_sha
      body["sha"][0..7]
    end

    def author_link
      "<https://github.com/#{author}|#{author}>"
    end

    def author
      body["sender"]["login"]
    end

    def pull_request_title
      body["pull_request"]["title"]
    end

    def pull_request_url
      body["pull_request"]["html_url"]
    end

    def pull_request_body
      body["pull_request"]["body"]
    end

    def suppressed_actions
      %w{assigned edited labeled synchronize unassigned unlabeled}
    end

    def response_color
      case action
      when "closed"
        "#f00"
      when "merged"
        "#6e5692"
      else
        "#36a64f"
      end
    end

    def response
      return if suppressed_actions.include?(action)
      {
        channel: "#notifications",
        text: title,
        attachments: [
          {
            color: response_color,
            fallback: fallback_title,
            title: "##{number} #{pull_request_title}",
            title_link: pull_request_url,
            text: pull_request_body,
            mrkdwn_in: [:text, :pretext]
          }
        ]
      }
    end
  end
end
