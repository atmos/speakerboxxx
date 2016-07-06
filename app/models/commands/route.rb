# Namespace for containing slash Commands
module Commands
  # Top-level class for implementing GitHub repo routing
  class Route < Default
    include RepositoryHelpers
    def initialize(command)
      super(command)
    end

    def self.help_documentation
      [
        "route atmos-org/speakerboxxx #tools - Route repo messages to a room.",
        "route:info atmos-org/speakerboxxx - Information about repo routing.",
        "route:help - Help information about repository routing."
      ]
    end

    def run
      if slack_team_github_organization
        case subtask
        when "info"
          info_subtask
        when "default", "", nil
          route_subtask
        else
          @response = help_for_task
        end
      else
        @response = response_for(
          "#{organization_name} isn't configured. Use org:enable"
        )
      end
    end

    def info_subtask
      default_room = slack_team_github_organization.default_room
      @response = response_for(
        "#{name_with_owner} is configured and routing to #{default_room}."
      )
    end

    def create_default_repostitory_name
      repo = slack_team_github_organization.repositories.find_or_create_by(
        name: repository_name
      ).tap { |r| r.default_room = room_name }
      repo.save
      repo
    end

    def route_subtask
      repo = create_default_repostitory_name
      @response = response_for(
        "#{name_with_owner} is configured and routing to #{repo.default_room}."
      )
    end
  end
end
