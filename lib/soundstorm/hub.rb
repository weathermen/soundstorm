module Soundstorm
  # Methods for pinging the Soundstorm Hub
  module Hub
    # URL to create a new Instance on the hub
    URL = 'https://stormhub.test/instances.json'

    # Parameters for the request.
    def self.params
      {
        host: Rails.configuration.host,
        version: Soundstorm::VERSION
      }
    end

    # Ping the hub and error if it cannot make the request.
    def self.ping!
      response = HTTP.post(URL, instance: params)
      raise "Error: #{response}" unless response.success?
    end
  end
end
