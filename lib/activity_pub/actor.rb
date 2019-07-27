# frozen_string_literal: true

module ActivityPub
  # Represents the entity that creates activity messages.
  class Actor
    extend ActiveSupport::Autoload

    autoload :Finger

    DEFAULT_TYPE = 'Person'

    attr_reader :name, :type, :host, :secret, :summary, :params

    delegate :public_key, to: :private_key
    delegate :to_json, to: :as_json

    def initialize(name:, type: DEFAULT_TYPE, host:, key:, secret:, summary:, **params)
      @name = name
      @type = type
      @host = host
      @summary = summary
      @key = key
      @secret = secret
      @params = params
    end

    def private_key
      @private_key ||= OpenSSL::PKey::RSA.new(@key, @secret)
    end

    # Find an +Actor+ remotely by its ID, a fully-qualified path to the
    # JSON for this actor on a remote server.
    #
    # @param [String] id - URL to the remote actor's profile
    # @return [Actor] or +nil+ if none can be found
    def self.find(id)
      uri = URI.parse(id)
      uri.path = "#{uri.path}.json" unless uri.path.end_with? '.json'
      response = HTTP.get(uri)

      return unless response.status.success?

      from(response.parse, host: uri.host)
    end

    # Parse a JSON response from a federated ActivityPub-speaking
    # instance to create a new Actor object.
    #
    # @param [Hash] json - JSON response
    # @option [String] host - Host the actor lives on
    # @return [ActivityPub::Actor]
    def self.from(json = {}, **options)
      params = json.deep_symbolize_keys
      params.merge!(options)
      key = params[:publicKey][:publicKeyPem]

      new(key: key, secret: nil, **params)
    end

    # ID of this actor, corresponding to the URL where their profile is
    # located.
    #
    # @return [String] URL to this user's profile
    def id
      @id ||= "https://#{host}/#{name}"
    end

    # Attributes for this Actor.
    #
    # @return [Hash] The `:name`, `:type`, `:host`, and `:key`
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
    # @return [Actor::Finger] Wrapped Webfinger attributes
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

    # Full JSON representation of this Actor.
    #
    # @return [Hash]
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

    # URL to a given sub-entity of this Actor.
    #
    # @param [String] path - Path to the JSON resource.
    # @return [String] Full URL of the resource.
    def url_for(path)
      params[path.to_sym] || "#{id}/#{path}.json"
    end
  end
end
