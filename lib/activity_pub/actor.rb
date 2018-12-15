# frozen_string_literal: true

module ActivityPub
  # Represents the entity that creates activity messages.
  class Actor
    DEFAULT_TYPE = 'Person'

    attr_reader :name, :type, :host, :secret, :summary, :private_key, :params

    delegate :public_key, to: :private_key
    delegate :to_json, to: :as_json

    def initialize(name:, type: DEFAULT_TYPE, host:, key:, secret:, summary:, **params)
      @name = name
      @type = type
      @host = host
      @summary = summary
      @private_key = OpenSSL::PKey::RSA.new(key, secret)
      @params = params
    end

    # Find an +Actor+ remotely by its ID, a fully-qualified path to the
    # JSON for this actor on a remote server.
    #
    # @return [Actor] or +nil+ if none can be found
    def self.find(id)
      response = HTTP.get(id)
      return unless response.success?

      from(response.parse)
    end

    def self.from(json = {}, **options)
      params = json.deep_symbolize_keys
      params.merge!(options)
      key = params[:publicKey][:publicKeyPem]

      new(key: key, secret: nil, **params)
    end

    def id
      @id ||= "https://#{host}/#{name}"
    end

    def attributes
      {
        name: name,
        type: type,
        host: host,
        key: private_key
      }
    end

    # Webfinger response for this Actor.
    #
    # @return [Actor::Finger]
    def webfinger
      Finger.new(
        name: name,
        host: host,
        href: id
      )
    end

    # Webfinger JSON representation for this Actor.
    #
    # @return [Hash]
    def as_webfinger
      webfinger.as_json
    end

    def as_json
      {
        '@context': [ACTIVITYSTREAMS_NAMESPACE, W3ID_NAMESPACE],
        type: type,
        id: id,
        following: url_for('following'),
        followers: url_for('followers'),
        liked: url_for('likes'),
        inbox: url_for('inbox'),
        outbox: url_for('outbox'),
        preferredUsername: name,
        name: name,
        summary: summary,
        publicKey: {
          id: "#{id}#main-key",
          owner: id,
          publicKeyPem: public_key.to_pem
        }
      }
    end

    def url_for(path)
      params[path.to_sym] || "#{id}/#{path}.json"
    end
  end
end
