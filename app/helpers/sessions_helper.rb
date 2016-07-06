# Helpers related to session authentication
module SessionsHelper
  def decoded_omniauth_origin_provider
    decoded_omniauth_origin &&
      %(heroku github).include?(decoded_omniauth_origin[:provider].to_s) &&
      decoded_omniauth_origin[:provider]
  end

  def decoded_params_origin
    JSON.parse(Base64.decode64(params[:origin])).with_indifferent_access
  rescue
    nil
  end

  def decoded_omniauth_origin
    JSON.parse(Base64.decode64(omniauth_origin)).with_indifferent_access
  rescue
    nil
  end

  def omniauth_origin
    request.env["omniauth.origin"]
  end

  def omniauth_info_user_id
    omniauth_info["info"]["user_id"]
  end

  def omniauth_bot_info
    omniauth_info["extra"] && omniauth_info["extra"]["bot_info"]
  end

  def omniauth_refresh_token
    omniauth_info["credentials"]["refresh_token"]
  end

  def omniauth_expiration
    Time.at(omniauth_info["credentials"]["expires_at"]).utc
  end

  def omniauth_info
    request.env["omniauth.auth"]
  end
end
