module GitHub::EventMessages
  # Class to generate Slack Messages based on a GitHub Delete Webhook
  class Delete
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
      @branch ||= body["ref"].sub("refs/heads/", "")
    end

    def repo_url
      "https://github.com/#{full_name}"
    end

    def branch_url
      "https://github.com/#{full_name}/tree/#{branch}"
    end

    def title
      "<#{repo_url}|[#{repo_name}]> The branch \"#{branch}\" " \
        " was deleted by #{commit_author}."
    end

    def fallback_title
      "[#{full_name}] The branch \"#{branch}\" was deleted by #{commit_author}."
    end

    def commit_author
      body["sender"]["login"]
    end

    def response
      {
        channel: "#notifications",
        attachments: [
          {
            fallback: fallback_title,
            color: "#4785c0",
            text: title,
            mrkdwn_in: [:text, :pretext]
          }
        ]
      }
    end
  end
end
