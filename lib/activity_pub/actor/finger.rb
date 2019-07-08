# frozen_string_literal: true

module ActivityPub
  class Actor
    # Representation of an Actor in the Webfinger protocol.
    class Finger
      # Self link relationship
      RELATIONSHIP = 'self'

      # HTTP Content-Type for this data.
      CONTENT_TYPE = 'application/activity+json'

      attr_reader :name, :host, :links

      # @param [String] name - Actor name
      # @param [String] host - Actor host
      # @param [String] href - Link to Actor's profile
      # @param [String] links - Alternate links
      def initialize(name:, host:, href: nil, links: [])
        @name = name
        @host = host
        @links = links.presence || [
          {
            rel: RELATIONSHIP,
            type: CONTENT_TYPE,
            href: href || "https://#{host}/#{name}"
          }
        ]
      end

      # Find remote Webfinger profile by their `acct:` URI
      #
      # @param [String] id - `acct:` URI for the user.
      # @return [ActivityPub::Actor::Finger] or `nil` if not found
      def self.find(id)
        name, host = id.gsub(/\Aacct:/, '').split('@')
        url = "https://#{host}/.well-known/webfinger?resource=#{id}"
        response = HTTP.get(url)

        return unless response.success?

        new(
          name: name,
          host: host,
          links: response.json['links']
        )
      end

      # `acct:` URI for the Actor.
      #
      # @return [String] URI conforming to the RFC 7565 `acct:` URI scheme
      def id
        @id ||= "acct:#{name}@#{host}"
      end

      # JSON representation of this Webfinger resource.
      #
      # @return [Hash] Attributes conforming to the Webfinger protocol
      def as_json
        {
          subject: id,
          links: links
        }
      end
    end
  end
end
