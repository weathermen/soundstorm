# frozen_string_literal: true

module ActivityPub
  # Sends a +Message+ over the ActivityPub protocol using HTTPS.
  class Broadcast
    attr_reader :message, :destination, :response, :date

    def initialize(message:, destination:)
      @message = message
      @destination = destination
      @date = Time.current
      @uri = URI.join("https://#{destination}", 'inbox.json')
    end

    def deliver
      @response ||= request.post(@uri, json: message.as_json)
    end

    def request
      @request ||= HTTP.headers(headers)
    end

    def headers
      @headers ||= {
        Host: destination,
        Date: message.date,
        Signature: signature.header
      }
    end

    def signature
      @signature ||= Signature.new(
        id: message.actor_id,
        host: destination,
        date: date,
        key: message.actor_private_key
      )
    end
  end
end
