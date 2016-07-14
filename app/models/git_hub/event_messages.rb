# Container module for GitHub webhook events
module GitHub::EventMessages
  def self.suppressed_actions
    %w{commit_comment deployment fork issues issue_comment \
       member membership pull_request_review_comment release repository \
       team_add watch}
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def self.handler_for(event_type, body)
    case event_type
    when "create"
      GitHub::EventMessages::Create.new(body)
    when "delete"
      GitHub::EventMessages::Delete.new(body)
    when "ping"
      GitHub::EventMessages::Ping.new(body)
    when "push"
      GitHub::EventMessages::Push.new(body)
    when "pull_request"
      GitHub::EventMessages::PullRequest.new(body)
    when "status"
      GitHub::EventMessages::Status.new(body)
    when "deployment_status"
      GitHub::EventMessages::DeploymentStatus.new(body)
    when *suppressed_actions
      nil
    else
      GitHub::EventMessages::Unknown.new(body, event_type)
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
end
