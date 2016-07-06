# Controller for handling incoming GitHub Organization webhooks
class WebhooksController < ApplicationController
  include WebhookValidations

  before_action :verify_incoming_github_webhook_address!
  before_action :verify_github_signature!
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    WebhookJob.perform_later(
      team_id: params[:team_id],
      org_name: params[:org_name],
      event_type: request.headers["HTTP_X_GITHUB_EVENT"],
      delivery_id: request.headers["HTTP_X_GITHUB_DELIVERY"],
      body: full_request_body
    )
    render json: {}, status: :created
  end

  private

  def full_request_body
    request.body.rewind
    request.body.read.force_encoding("utf-8")
  end
end
