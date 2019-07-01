# frozen_string_literal: true

Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = true

  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_mailer.perform_caching     = true

  # Don't require a master key, read secrets from the environment
  config.require_master_key = false

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = Soundstorm::SERVE_STATIC_FILES

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from a CDN
  config.action_controller.asset_host = Soundstorm::CDN_URL

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on Amazon S3
  config.active_storage.service = :amazon

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use Redis to store the fragment cache in production
  config.cache_store = :redis_cache_store, {
    url: "#{Soundstorm::REDIS_CACHE_URL}/0"
  }

  # Use a separate Redis database for the page cache
  config.action_dispatch.rack_cache = {
    metastore: "#{Soundstorm::REDIS_CACHE_URL}/1/metastore",
    entitystore: "#{Soundstorm::REDIS_CACHE_URL}/1/entitystore"
  }

  # Use Sidekiq for background jobs
  config.active_job.queue_adapter     = :sidekiq
  config.active_job.queue_name_prefix = "soundstorm_#{Rails.env}"

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  ActionMailer::Base.smtp_settings = {
    user_name: Soundstorm::SMTP_USERNAME,
    password: Soundstorm::SMTP_PASSWORD,
    domain: Soundstorm::HOST,
    address: Soundstorm::SMTP_HOST,
    port: Soundstorm::SMTP_PORT,
    authentication: Soundstorm::SMTP_AUTH,
    enable_starttls_auto: Soundstorm::SMTP_TLS
  }
end
