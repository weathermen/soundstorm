module ActivityPub
  # Received activity from the inbox.
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

    # The actual model record
    def model
      model_class.find_or_create_by(slug: model_id) do |record|
        record.attributes = payload
      end
    end

    private

    # Slug of the model
    def model_id
      File.basename(payload[:id], '.json')
    end

    # Type of this model
    def model_type
      payload[:type]
    end

    # Class of the model
    def model_class
      model_type.constantize
    end
  end
end
