# frozen_string_literal: true

module Soundstorm
  # Pings the Soundstorm Hub, a directory of all Soundstorm instances
  module Hub
    extend self

    # Parameters for the request.
    def params
      {
        host: Rails.configuration.host,
        version: Soundstorm::VERSION
      }
    end

    # Base URL to the hub.
    def host
      if Rails.env.production?
        'https://hub.soundstorm.social'
      else
        'http://stormhub.test'
      end
    end

    # URL to create a new Instance on the hub
    def url
      "#{host}/instances.json"
    end

    # Ping the hub.
    def ping
      Rails.logger.info "Pinging #{url}"
      HTTP.post(url, json: { instance: params })
    rescue HTTP::ConnectionError => error
      Rails.logger.error "Error pinging Soundstorm Hub: #{error.message}"
    end
  end
end
