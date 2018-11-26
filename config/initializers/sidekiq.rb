# frozen_string_literal: true

if defined? Sidekiq
  Sidekiq.configure_server do |config|
    config.redis = Soundstorm::REDIS_CONFIG.merge(database: 2)
  end

  Sidekiq.configure_client do |config|
    config.redis = Soundstorm::REDIS_CONFIG.merge(database: 2)
  end
end
