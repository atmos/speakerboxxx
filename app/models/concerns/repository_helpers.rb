# Module for handling interacting with GitHub organizations
module RepositoryHelpers
  extend ActiveSupport::Concern

  included do
  end

  # Things exposed to the included class as class methods
  module ClassMethods
  end

  def organization_name_pattern
    /route(?:\:[^\s]+)? (.*)\s*/
  end

  def github_api
    user.github_api_client
  end

  def slack_team
    @slack_team ||= command.slack_team
  end

  def valid_slug
    Regexp.new("([-_\.0-9a-z]+/[-_\.0-9a-z]+)\s*(#[-_\.0-9a-z]+)?")
  end

  def room_name
    @room_name ||= command.command_text.match(valid_slug)[2]
  end

  def name_with_owner
    @name_with_owner ||= command.command_text.match(valid_slug)[1]
  end

  def organization_name
    return unless name_with_owner
    name_with_owner.split("/").first
  end

  def repository_name
    return unless name_with_owner
    name_with_owner.split("/").last
  end

  def organization
    @organization ||= begin
                        github_api.organization(organization_name)
                      rescue Octokit::NotFound
                        nil
                      end
  end

  def organization_webhooks
    @organization_webhooks ||= begin
                              github_api.org_hooks(organization_name)
                            rescue Octokit::NotFound
                              nil
                            end
  end

  def organization?
    !organization.nil?
  end

  def org_hook
    return if organization_webhooks.nil?
    organization_webhooks.find do |hook|
      hook.config.url == organization_webhook_url
    end
  end

  def org_hooks?
    !org_hook.nil?
  end

  def organization_webhook_url
    "https://#{ENV['HOSTNAME']}" \
      "/webhooks/#{slack_team.team_id}/github/#{organization_name}"
  end

  def slack_team_github_organization
    slack_team.organizations.find do |org|
      org.name == organization_name
    end
  end
end
