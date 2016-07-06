# Namespace for containing slash Commands
module Commands
  # Top-level class for implementing chat commands
  class Default
    include ActionView::Helpers::DateHelper

    COLOR = "#6567a5".freeze
    UUID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

    REPO_REGEX = %r{([-_\.0-9a-z]+)/([-_\.0-9a-z]+)}

    attr_reader :client, :command, :description, :response
    delegate :application, :subtask, :task, :user, :slack_team, to: :@command

    def initialize(command)
      @command = command

      @description = command.description.gsub("Running", "Ran")
      @response    = { text: description, response_type: "in_channel" }
    end

    def run
      # Overridden in each subclass
    end

    def self.help_documentation
      []
    end

    def slash_command_prefix
      Speakerboxxx.slash_command_prefix
    end

    def help_for_task
      {
        response_type: "in_channel",
        attachments: [
          {
            text: self.class.help_documentation.join("\n"),
            pretext: "Run #{slash_command_prefix} help",
            fallback: "Help commands from the GitHub integration",
            title: "Available speakerboxxx #{task} commands:",
            title_link: "https://speakerboxxx.atmos.org"
          }
        ]
      }
    end

    def error_response_for(text)
      { response_type: "in_channel",
        attachments: [{ text: text, color: "#f00" }] }
    end

    def response_for(text)
      { text: text, response_type: "in_channel" }
    end
  end
end
