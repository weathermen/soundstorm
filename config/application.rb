# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'activity_pub'
require 'soundstorm'
require 'elasticsearch/rails/instrumentation'
# require 'elasticsearch/rails/lograge'
require 'i18n/backend/active_record'

module Soundstorm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |generate|
      generate.assets false
    end

    # Set the host from the $HOST environment variable. Use this
    # configuration for other settings like the GlobalID app name and
    # ActionMailer base URL host
    config.host = Soundstorm::HOST
    config.action_mailer.default_url_options = { host: config.host }
    config.global_id.app = config.host

    # Expire page caches in 15 minutes
    config.page_cache_ttl = 15.minutes

    # Use the Rails app for rendering errors.
    config.exceptions_app = routes

    config.to_prepare do
      Doorkeeper::ApplicationsController.layout 'application'
    end

    config.after_initialize { Soundstorm::Hub.ping }

    # Allow admins to override any copy
    config.i18n.backend = I18n::Backend::Chain.new(
      I18n::Backend::ActiveRecord.new,
      I18n::Backend::Simple.new
    )

    # Auto load all translations from config/locales/**/*.yml (and sub-directories).
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
  end
end
