# Top-level controller all web endpoints inherit from
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def install
    redirect_to "/auth/slack_install"
  end

  private

  def peek_enabled?
    true
  end

  def authenticate!
    true
  end
end
