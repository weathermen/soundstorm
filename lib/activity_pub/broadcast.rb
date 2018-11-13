module ActivityPub
  # Sends a +Message+ over the ActivityPub protocol using HTTPS.
  class Broadcast
    attr_reader :message, :destination, :response, :date

    def initialize(message:, destination:)
      @message = message
      @destination = destination
    end

    def deliver
      @response ||= request.post(destination, body: message.as_json)
      @response.success?
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
        actor: message.actor,
        date: message.date
      )
    end
  end
end
