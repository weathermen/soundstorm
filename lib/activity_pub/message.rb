module ActivityPub
  # Represents a message object on the +ActivityPub+ protocol, used for
  # encapsulating activity updates for transmission to other peers.
  class Message
    attr_reader :id, :type, :published, :actor, :parent_id, :content

    def initialize(id:, type:, published: nil, actor:, parent_id: nil, content:)
      @id = id
      @type = type
      @published = published || Time.current
      @actor = actor
      @parent_id = parent_id
      @content = content
    end

    def date
      published.utc.httpdate
    end

    def as_json
      {
        "@context": ACTIVITYSTREAMS_NAMESPACE,
        id: id,
        type: type,
        actor: actor.id,
        object: attributes
      }
    end

    def attributes
      {
        id: id,
        type: type,
        published: date,
        attributedTo: actor.id,
        inReplyTo: parent_id,
        content: content,
        to: "#{ACTIVITYSTREAMS_NAMESPACE}#Public"
      }
    end

    def signature
      @signature ||= Signature.new(date: date, private_key: actor.private_key)
    end
  end
end
