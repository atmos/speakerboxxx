module Speakerboxxx
  def self.slash_command_prefix
    ENV["SLACK_SLASH_COMMAND_PREFIX"] || "/gh"
  end
end
