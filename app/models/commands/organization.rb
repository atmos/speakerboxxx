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
        "org:enable heroku #my-default-channel - " \
        "Enable the heroku organization's webhooks",
        "org:disable heroku - Disable the heroku organization's webhooks"
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
        when "default"
          default_subtask
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
      unless channel_name.blank?
        github_organization.default_room = channel_name
        github_organization.save
      end

      unless org_hooks?
        create_organization_hook(github_organization.webhook_secret)
        @organization_hooks = nil
      end

      @response = response_for(
        "#{organization_name} webhooks are enabled. Defaulting to " \
          "#{github_organization.default_room} " \
          "<#{organization_webhook_view_url}|View>"
      )
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
        @response = response_for(
          "#{organization_name} is good to go. " \
            "Defaulting to #{github_organization.default_room}"
        )
      else
        @response = response_for("#{organization_name} isn't configured.")
      end
    end
  end
end
