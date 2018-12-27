# frozen_string_literal: true

require 'soundstorm/version'
require 'soundstorm/hub'

# Environment configuration that pertains to the Rails app
module Soundstorm
  HOST = ENV.fetch('SOUNDSTORM_HOST', 'soundstorm.test')

  ADMIN_USERNAME = ENV.fetch('SOUNDSTORM_ADMIN_USERNAME', 'admin')
  ADMIN_PASSWORD = ENV.fetch('SOUNDSTORM_ADMIN_PASSWORD', 'Password1!')
  ADMIN_EMAIL = ENV.fetch('SOUNDSTORM_ADMIN_EMAIL', 'admin@example.com')

  CDN_URL = ENV['SOUNDSTORM_CDN_URL']

  AWS_ACCESS_KEY = ENV['AWS_ACCESS_KEY_ID']
  AWS_SECRET_KEY = ENV['AWS_SECRET_ACCESS_KEY']
  AWS_REGION     = ENV['AWS_REGION']
  AWS_S3_BUCKET  = ENV['AWS_S3_BUCKET_NAME']

  REDIS_CONFIG = {
    host: 'redis',
    port: 6379
  }

  DATABASE_URL = ENV['DATABASE_URL']

  SERVE_STATIC_FILES = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # URL to the Soundstorm engineering blog
  BLOG_URL    = 'https://blog.soundstorm.social'

  # URL to the canonical source code repository
  SOURCE_URL  = 'https://github.com/weathermen/soundstorm'

  # URL to the documentation for Soundstorm
  DOCS_URL    = 'https://docs.soundstorm.social'
end
