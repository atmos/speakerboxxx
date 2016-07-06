Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  if Rails.env.test? || Rails.env.development?
    config.enabled = false
  end
end
