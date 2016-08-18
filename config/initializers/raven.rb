Raven.configure do |config|
  config.environments = ["staging", "production"]
  if ENV["SENTRY_DSN"]
    config.dsn = ENV["SENTRY_DSN"]
  end
end
