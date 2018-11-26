# frozen_string_literal: true

module ActivityPub
  # Verifies a request by passing a Signature header and checking it
  # against a real-life Actor.
  class Verification
    attr_reader :date, :attributes, :key_id, :headers, :signature, :options

    delegate :public_key, to: :actor

    # @param [String] signature - Signature header
    # @param [Time] date - Date from the 'Date' header
    # @param [Hash] options - Additional headers to sign with the request
    def initialize(signature, date, **options)
      @date = date
      @attributes = signature.split(',').each_with_object({}) do |pair, params|
        param, value = pair.split('=').map { |str| dequote(str) }
        params[param] = value
      end
      @key_id    = attributes['keyId']
      @headers   = attributes['headers']
      @signature = Base64.decode64(attributes['signature'])
      @options = options
    end

    def valid?
      verified? && fresh?
    end

    def verified?
      public_key.verify(ActivityPub.digest, signature, comparison)
    end

    def fresh?
      date >= 15.minutes.ago
    end

    # @return [String]
    def comparison
      @comparison ||= headers.split(' ').map do |signed_header_name|
        if signed_header_name == '(request-target)'
          '(request-target): post /inbox'
        elsif signed_header_name == 'date'
          "#{signed_header_name}: #{date.httpdate}"
        else
          "#{signed_header_name}: #{options[signed_header_name.to_sym]}"
        end
      end.join("\n")
    end

    def actor
      @actor ||= Actor.find(key_id)
    end

    private

    def dequote(str)
      str.gsub(/\A"/, '').gsub(/"\z/, '')
    end
  end
end
