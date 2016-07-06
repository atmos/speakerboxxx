# Top-level controller all web endpoints inherit from
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def health
    render json: { name: "speakerboxxx/the-love-below" }, status: :ok
  end

  def boomtown
    raise("Intentional exception from the web app")
  end

  private

  def peek_enabled?
    true
  end

  def authenticate!
    true
  end
end
