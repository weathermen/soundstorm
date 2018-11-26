# frozen_string_literal: true

require 'http'
require 'openssl'
require 'active_support/all'

# A library for transmitting messages over +ActivityPub+, intended to be
# implemented by servers which federate with each other over the aforementioned
# protocol.
module ActivityPub
  extend ActiveSupport::Autoload

  # URL to the Activity Streams standard, used for +@context+ values in
  # Message and Actor JSON.
  ACTIVITYSTREAMS_NAMESPACE = 'https://www.w3.org/ns/activitystreams'

  # URL to the W3ID standard, used for +@context+ values in Actor JSON.
  W3ID_NAMESPACE = 'https://w3id.org/security/v1'

  autoload :Actor
  autoload :Activity
  autoload :Message
  autoload :Broadcast
  autoload :Signature
  autoload :Verification

  # Deliver a +Message+ to the given +:to+ host.
  #
  # @param [ActivityPub::Message] message - Message to deliver
  # @param [String] to - Host to send to
  def self.deliver(message, to:)
    Broadcast.new(message: message, destination: to).tap(&:deliver)
  end

  # Verify an HTTP request using "Signature" and "Date" headers.
  #
  # @param [String] signature - HTTP "Signature" header contents
  # @param [String] date - HTTP "Date" header contents
  # @return [Boolean] whether the request is verified
  def self.verify(signature, date)
    Verification.new(signature, date).valid?
  end

  # Algorithm used for digesting shared secrets.
  #
  # @return [OpenSSL::Digest::SHA256]
  def self.digest
    @digest ||= OpenSSL::Digest::SHA256.new
  end
end
