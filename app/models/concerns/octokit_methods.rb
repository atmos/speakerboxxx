# Module for handling encrypting/descrypting strings to columns.
module OctokitMethods
  extend ActiveSupport::Concern

  included do
  end

  # Things exposed to the included class as class methods
  module ClassMethods
  end

  def github_api_client
    @github_api_client ||= Octokit::Client.new(access_token: github_token)
  end

  def organization_info
    github_api_client.org_hooks
  end
end
