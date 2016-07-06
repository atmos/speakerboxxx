require_relative 'boot'

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Speakerboxxx
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.assets = false
      g.helper = false
      g.view_specs = false
    end

    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      { request_id: event.payload[:request_id] }
    end

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
