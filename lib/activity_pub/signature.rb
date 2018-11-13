module ActivityPub
  # Signed String for ActivityPub traffic.
  class Signature
    HEADERS = '(request-target) host date'

    attr_reader :actor, :date, :private_key, :digest

    delegate :host, :id, :private_key, to: :actor

    def initialize(actor:, date:)
      @actor = actor
      @date = date
      @digest = OpenSSL::Digest::SHA256.new
    end

    # Unsigned contents of string.
    def to_unsigned_s
      <<-STR
        (request-target): post /inbox
        host: https://#{host}
        date: #{date}
      STR
    end

    # Contents of signed string.
    def to_s
      private_key.sign(digest, to_unsigned_s)
    end

    # Attributes for signed string.
    def attributes
      {
        keyId: id,
        headers: HEADERS,
        signature: to_s
      }
    end

    # HTTP header combining all attributes.
    def header
      @header ||= attributes.map { |key, value| %(#{key}="#{value}") }.join(',')
    end
  end
end
