# Concern for handling GitHub organization webhooks
module WebhookValidations
  extend ActiveSupport::Concern

  def verify_incoming_github_webhook_address!
    sources = ["192.30.252.0/22"]
    if Rails.env.development?
      sources << "127.0.0.1/32"
    end

    if sources.any? { |block| IPAddr.new(block).include?(request.ip) }
      true
    else
      render json: {}, status: :forbidden
    end
  end

  def verify_github_signature!
    return false unless github_signature_verification_enabled?

    request.body.rewind
    signature = signature_for_github_payload(request.body.read)

    verified = ActiveSupport::SecurityUtils.secure_compare(
      signature,
      github_webhook_signature
    )
    return true if verified

    render json: {}, status: :forbidden
  end

  def signature_for_github_payload(payload)
    hex = OpenSSL::HMAC.hexdigest(github_digest, github_webhook_secret, payload)
    "sha1=#{hex}"
  end

  def github_digest
    OpenSSL::Digest.new("sha1")
  end

  def webhook_slack_team
    @webhook_slack_team ||= SlackHQ::Team.find_by(team_id: params[:team_id])
  end

  # rubocop:disable Metrics/LineLength
  def github_webhook_secret
    @github_webhook_secret ||=
      webhook_slack_team.organizations.find_by(name: params[:org_name]).webhook_secret
  end
  # rubocop:enable Metrics/LineLength

  def github_webhook_signature
    request.headers["HTTP_X_HUB_SIGNATURE"]
  end

  def github_signature_verification_enabled?
    github_webhook_secret && github_webhook_signature
  end
end
