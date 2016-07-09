module GitHub::EventMessages
  # Class to generate Slack Messages based on a GitHub Ping Webhook
  class Ping
    attr_accessor :body
    def initialize(body)
      @body = body
    end

    def repo_name
      nil
    end

    def full_name
      body["repository"]["full_name"]
    end

    def organization
      body["organization"]
    end

    def hook_id
      body["hook_id"]
    end

    def org_name
      organization["login"]
    end

    def zen
      body["zen"]
    end

    def title
      "Webhooks enabled: :bell:"
    end

    def hook_link
      "#{org_link}/hooks/#{hook_id}"
    end

    def org_link
      "https://github.com/organizations/#{org_name}/settings"
    end

    # rubocop:disable Metrics/MethodLength
    def response
      {
        channel: "#notifications",
        attachments: [
          {
            color: "#4785c0",
            title: title,
            fields: [
              {
                title: "Organization",
                value: "<#{org_link}|#{org_name}>",
                short: true
              },
              {
                title: "Admin",
                value: "<#{hook_link}|On GitHub>",
                short: true
              },
              {
                title: "Status",
                value: "Enabled",
                short: true
              },
              {
                title: "Zen",
                value: zen,
                short: true
              }
            ],
            mrkdwn_in: [:text, :pretext]
          }
        ]
      }
    end
    # rubocop:enable Metrics/MethodLength
  end
end
