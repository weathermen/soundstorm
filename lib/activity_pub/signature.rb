module ActivityPub
  # Signed String for ActivityPub traffic.
  class Signature
    DEFAULT_HEADERS = '(request-target) host date'

    attr_reader :id, :host, :date, :key, :headers

    def initialize(id:, host:, date:, key:, headers: DEFAULT_HEADERS)
      @id = id
      @host = host
      @date = date
      @key = key
      @headers = headers
    end

    # Unsigned contents of string.
    def to_unsigned_s
      str = <<~STR
        (request-target): post /inbox
        host: https://#{host}
        date: #{date.httpdate}
      STR
      str.strip
    end

    # Contents of signed string.
    def to_signed_s
      key.sign(ActivityPub.digest, to_unsigned_s)
    end

    def to_s
      Base64.encode64(to_signed_s)
    end

    # Attributes for signed string.
    def attributes
      {
        keyId: id,
        headers: headers,
        signature: to_s
      }
    end

    # HTTP header combining all attributes.
    def header
      @header ||= attributes.map { |key, value| %(#{key}="#{value}") }.join(',')
    end
  end
end
