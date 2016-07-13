# Top-level controller all web endpoints inherit from
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def boomtown
    raise("Intentional exception from the web app")
  end

  def health
    render json: { name: "speakerboxxx/the-love-below" }, status: :ok
  end

  def install
    redirect_to "/auth/slack?scope=identify,commands,bot"
  end

  private

  def peek_enabled?
    true
  end

  def authenticate!
    true
  end
end
