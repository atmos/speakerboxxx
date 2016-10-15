module GitHub::EventMessages
  # Class to generate Slack Messages based on an known GitHub Webhook
  class Unknown
    attr_accessor :body, :event_type, :repo_name
    def initialize(body, event_type)
      @body       = body
      @repo_name  = nil
      @event_type = event_type
    end

    def title
      "#{event_type} :smiley:"
    end

    def fallback_title
      title
    end

    def commit_author
      body["sender"]["login"]
    end

    def response
      {
        channel: "#notifications",
        attachments: [
          {
            text: title,
            color: "#4785c0",
            fallback: fallback_title,
            mrkdwn_in: [:text, :pretext]
          }
        ]
      }
    end
  end
end
