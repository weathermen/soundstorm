# frozen_string_literal: true

require 'soundstorm/version'
require 'soundstorm/hub'

# The constants in this top-level module are configuration passed into
# the app from environment variables. Here is where their defaults are
# expressed and documented.
module Soundstorm
  # Hostname to the Soundstorm server
  HOST = ENV.fetch('SOUNDSTORM_HOST', 'soundstorm.test')

  # Name of the initial admin user created at setup. Defaults to +admin+
  ADMIN_USERNAME = ENV.fetch('SOUNDSTORM_ADMIN_USERNAME', 'admin')

  # Password for the initial user created at setup. Defaults to +Password1!+
  ADMIN_PASSWORD = ENV.fetch('SOUNDSTORM_ADMIN_PASSWORD', 'Password1!')

  # Email address for the initial user created at setup. Defaults to +admin@example.com+
  ADMIN_EMAIL = ENV.fetch('SOUNDSTORM_ADMIN_EMAIL', 'admin@example.com')

  # URL to the CDN, typically provided by CloudFront, that serves as a
  # front-end to static assets in production to enhance speed and
  # efficiency of streaming/downloading audio.
  CDN_URL = ENV['SOUNDSTORM_CDN_URL']

  # Access key for Amazon S3 authentication
  AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY_ID']

  # Secret key for Amazon S3 authentication
  AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']

  # AWS region the server operates in
  AWS_REGION     = ENV['AWS_REGION']

  # S3 bucket for storage assets
  AWS_S3_BUCKET  = ENV['AWS_S3_BUCKET_NAME']

  # URL to the PostgreSQL server
  DATABASE_URL = ENV['DATABASE_URL']

  # URL to the Redis server
  REDIS_URL = ENV['REDIS_URL']

  # Whether to serve static files in production. Defaults to +false+.
  SERVE_STATIC_FILES = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Whether to forward all logs to STDOUT. Defaults to +true+ on
  # containers.
  LOG_TO_STDOUT = ENV['RAILS_LOG_TO_STDOUT'].present?

  # URL to the Soundstorm engineering blog
  BLOG_URL    = 'https://blog.soundstorm.social'

  # URL to the canonical source code repository
  SOURCE_URL  = 'https://github.com/weathermen/soundstorm'

  # URL to the documentation for Soundstorm
  DOCS_URL    = 'https://docs.soundstorm.social'

  # SMTP hostname for sending emails, defaults to Sendgrid
  SMTP_HOST     = ENV.fetch('SMTP_HOST', 'smtp.sendgrid.net')

  # SMTP hostname for sending emails, defaults to 587
  SMTP_PORT     = ENV.fetch('SMTP_PORT', 587)

  # Username for authenticating to SMTP server
  SMTP_USERNAME = ENV['SMTP_USERNAME']

  # Password for authenticating to SMTP server
  SMTP_PASSWORD = ENV['SMTP_PASSWORD']

  # Authentication type that SMTP server supports, defaults to +:plain+.
  SMTP_AUTH     = ENV.fetch('SMTP_AUTH', :plain).to_sym

  # Whether to use TLS when transmitting mails, defaults to `true`.
  SMTP_TLS      = !!(ENV['SMTP_TLS'] !~ /false/)
end
