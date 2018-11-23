module Soundstorm
  # Methods for pinging the Soundstorm Hub
  module Hub
    # URL to create a new Instance on the hub
    URL = 'http://stormhub.test/instances.json'

    # Parameters for the request.
    def self.params
      {
        host: Rails.configuration.host,
        version: Soundstorm::VERSION
      }
    end

    # Ping the hub.
    def self.ping
      HTTP.post(URL, json: { instance: params })
    end
  end
end
