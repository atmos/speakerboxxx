module GitHub::EventMessages
  # Class to generate Slack Messages based on a GitHub Push Webhook
  class Push
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

    def branch_url
      "https://github.com/#{full_name}/tree/#{branch}"
    end

    def commits_text
      ActionController::Base.helpers.pluralize(commits.size, "new commit")
    end

    def title
      "<#{branch_url}|[#{repo_name}:#{branch}]> " \
        "#{commits_text} by #{commit_author}:"
    end

    def fallback_title
      "[#{repo_name}:#{branch}] #{commits_text} by #{commit_author}"
    end

    def short_sha
      body["after"][0..7]
    end

    def commit_author
      commits.any? && commits.first["committer"]["name"]
    end

    def commit_comment_description
      commits.any? && commits.first["message"]
    end

    def commit_comment
      "#{commit_comment_description} - #{commit_author}"
    end

    def commits
      body["commits"]
    end

    def response
      return if commits.empty?
      return if short_sha == "00000000"
      {
        channel: "#notifications",
        text: title,
        attachments: [
          {
            fallback: fallback_title,
            color: "#4785c0",
            text: "`#{short_sha}` #{commit_comment}",
            mrkdwn_in: [:text, :pretext]
          }
        ]
      }
    end
  end
end
