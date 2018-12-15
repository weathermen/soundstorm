# frozen_string_literal: true

module ActivityPub
  class Actor
    # Webfinger response for an Actor.
    class Finger
      RELATIONSHIP = 'self'
      CONTENT_TYPE = 'application/activity+json'

      attr_reader :name, :host, :href

      def initialize(name:, host:, href:)
        @name = name
        @host = host
        @href = href
      end

      def self.find(id)
        uri = URI.parse(id)
        response = HTTP.get("https://#{host}/.well-known/webfinger")
        return unless response.success?
        link = response.json['links'].find { |l| l['rel'] == RELATIONSHIP }

        new(
          name: uri.name,
          host: uri.host,
          href: link['href']
        )
      end

      def id
        @id ||= "acct:#{name}@#{host}"
      end

      def as_json
        {
          subject: id,
          links: [
            {
              rel: RELATIONSHIP,
              type: CONTENT_TYPE,
              href: actor_id
            }
          ]
        }
      end
    end
  end
end
