require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

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

    config.host = ENV.fetch('HOST', 'soundstorm.test')
    config.action_mailer.default_url_options = { host: config.host }

    config.activity_streams_context = [
      'https://www.w3.org/ns/activitystreams',
      'https://w3id.org/security/v1'
    ]

    config.page_cache_ttl = 15.minutes
  end
end
