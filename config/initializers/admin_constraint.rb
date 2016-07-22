class AdminConstraint
  ADMIN_UIDS = ENV.fetch("GITHUB_ADMIN_LOGINS", "").split(",").freeze

  def matches?(request)
    return false unless request.session[:user_id]
    u = SlackHQ::User.find(request.session[:user_id])
    return false unless u.github_login.present?
    ADMIN_UIDS.include?(u.github_login)
  end
end
