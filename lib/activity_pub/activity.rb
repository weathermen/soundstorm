module ActivityPub
  # Incoming activity from another federated instance.
  class Activity
    include GlobalID::Identification

    attr_reader :activity_id, :type, :actor, :payload

    def initialize(id:, type:, actor:, object:, host: nil, **options)
      @activity_id = id
      @type = type
      @actor = actor.is_a?(String) ? Actor.find(actor) : Actor.from(actor, host: host)
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
        actor: actor.id,
        object: payload
      }
    end
  end
end
