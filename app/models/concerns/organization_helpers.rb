# Module for handling interacting with GitHub organizations
module OrganizationHelpers
  extend ActiveSupport::Concern

  included do
  end

  # Things exposed to the included class as class methods
  module ClassMethods
  end

  def organization_name_pattern
    /org(?:\:[^\s]+)? ([^\s]+)\s*([^\s]+)?\s*/
  end

  def github_api
    user.github_api_client
  end

  def organization_name
    @organization_name ||=
      command.command_text.match(organization_name_pattern)[1]
  end

  def channel_name
    @channel_name ||= command.command_text.match(organization_name_pattern)[2]
  end

  def organization
    @organization ||= begin
                        github_api.organization(organization_name)
                      rescue Octokit::NotFound
                        nil
                      end
  end

  def organization_hooks
    @organization_hooks ||= begin
                              github_api.org_hooks(organization_name)
                            rescue Octokit::NotFound
                              nil
                            end
  end

  def create_organization_hook(secret)
    config = {
      url: organization_webhook_url,
      secret: secret,
      content_type: "json"
    }
    options = {
      name: "web",
      events: ["*"],
      active: true
    }
    create_github_organization_hook(config, options)
  end

  def create_github_organization_hook(config, options)
    github_api.create_org_hook(organization_name, config, options)
  rescue Octokit::NotFound
    nil
  end

  def remove_organization_hook
    return unless org_hook
    github_api.remove_org_hook(organization_name, org_hook.id)
  rescue Octokit::NotFound
    nil
  end

  def organization?
    !organization.nil?
  end

  def organization_webhook_view_url
    return unless org_hook
    "https://github.com/organizations/#{organization_name}/" \
      "settings/hooks/#{org_hook.id}"
  end

  def organization_webhook_url
    "https://#{ENV['HOSTNAME']}" \
      "/webhooks/#{slack_team.team_id}/github/#{organization_name}"
  end

  def org_hook
    return if organization_hooks.nil?
    organization_hooks.find do |hook|
      hook.config.url == organization_webhook_url
    end
  end

  def org_hooks?
    !org_hook.nil?
  end
end
