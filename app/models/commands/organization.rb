# Namespace for containing slash Commands
module Commands
  # Top-level class for implementing GitHub org commands
  class Organization < Default
    include OrganizationHelpers
    def initialize(command)
      super(command)
    end

    def self.help_documentation
      [
        "org:info heroku - Get information about a GitHub organization",
        "org:enable heroku - Enable the heroku organization's webhooks",
        "org:disble heroku - Disable the heroku organization's webhooks"
      ]
    end

    def run
      if organization?
        case subtask
        when "info"
          info_subtask
        when "enable"
          enable_subtask
        when "disable"
          disable_subtask
        else
          @response = help_for_task
        end
      else
        @response = response_for("#{organization_name} isn't an organization.")
      end
    end

    def github_organization
      @github_organization ||=
        slack_team.organizations.find_or_create_by(name: organization_name)
    end

    def enable_subtask
      if org_hooks?
        @response = response_for("#{organization_name} is already enabled.")
      else
        create_organization_hook(github_organization.webhook_secret)
        @organization_hooks = nil

        @response = response_for(
          "#{organization_name} webhooks are enabled. " \
          "<#{organization_webhook_view_url}|View>"
        )
      end
    end

    def disable_subtask
      if org_hooks?
        if remove_organization_hook
          @response = response_for(
            "#{organization_name} webhooks are disabled."
          )
        else
          @response = response_for(
            "Problem removing #{organization_name}'s webhooks."
          )
        end
      else
        @response = response_for(
          "#{organization_name} is already disabled."
        )
      end
    end

    def info_subtask
      if org_hooks?
        @response = response_for("#{organization_name} is good to go :+1:.")
      else
        @response = response_for("#{organization_name} isn't configured.")
      end
    end
  end
end
