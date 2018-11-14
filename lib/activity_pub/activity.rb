module ActivityPub
  # Incoming activity from another federated instance.
  class Activity
    attr_reader :id, :type, :actor, :payload

    def initialize(id:, type:, actor:, object:)
      @id = id
      @type = type
      @actor = Actor.new(**actor)
      @payload = object
    end

    # GlobalID of the author actor object
    def author
      actor.to_global_id
    end

    # Attributes of this activity receipt.
    def attributes
      {
        id: id,
        type: type,
        author: author,
        object: payload
      }
    end
  end
end
