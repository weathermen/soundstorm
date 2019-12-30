# frozen_string_literal: true

require 'soundstorm/version'

# The constants in this top-level module are configuration passed into
# the app from environment variables. Here is where their defaults are
# expressed and documented.
module Soundstorm
  extend ActiveSupport::Autoload

  autoload :Hub
  autoload :Client

  def self.connect(host)
    Client.new(base_url: host)
  end

  # URL to the single Redis server in development
  REDIS_URL = ENV.fetch('REDIS_URL', 'redis://redis:6379')

  # URL to the Redis server for storing the cache
  REDIS_CACHE_URL = ENV['REDIS_CACHE_URL'] || REDIS_URL

  # URL to the Redis server for storing the background job queue
  REDIS_QUEUE_URL = ENV['REDIS_QUEUE_URL'] || REDIS_URL

  # URL to the Soundstorm engineering blog
  BLOG_URL    = 'https://blog.soundstorm.social'

  # URL to the canonical source code repository
  SOURCE_URL  = 'https://github.com/weathermen/soundstorm'

  # URL to the documentation for Soundstorm
  DOCS_URL    = 'https://docs.soundstorm.social'
end
