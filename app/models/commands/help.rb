# Namespace for containing slash Commands
module Commands
  # Top-level class for implementing Heroku commands
  class Help < Default
    def initialize(command)
      super(command)
    end

    def self.help_documentation
      [
        Commands::Organization.help_documentation,
        Commands::Route.help_documentation
      ].flatten
    end

    def run
      @response = help_for_task
    end
  end
end
