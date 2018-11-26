# frozen_string_literal: true

module ActivityPub
  # Incoming activity from another federated instance.
  class Activity
    include GlobalID::Identification

    attr_reader :activity_id, :type, :actor, :payload

    delegate :to_json, to: :as_json
    delegate :id, to: :actor, prefix: true

    def initialize(id:, type:, actor:, object:, host: nil, **_options)
      @activity_id = id
      @type = type
      @actor = case actor
               when String
                 Actor.find(actor)
               when Hash
                 Actor.from(actor, host: host)
               end
      @payload = object
    end

    def id
      Base64.encode64(attributes.to_json)
    end

    def self.find(id)
      attributes = JSON.parse(Base64.decode64(id)).symbolize_keys

      new(**attributes)
    end

    # Attributes of this activity receipt.
    def attributes
      {
        id: activity_id,
        type: type,
        actor: actor_id,
        object: payload
      }
    end

    def as_json
      attributes.reverse_merge(
        '@context': ActivityPub::ACTIVITYSTREAMS_NAMESPACE
      )
    end
  end
end
