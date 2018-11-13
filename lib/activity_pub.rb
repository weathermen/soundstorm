require 'http'
require 'openssl'
require 'active_support/all'

# A library for transmitting messages over +ActivityPub+, intended to be
# implemented by servers which federate with each other over the aforementioned
# protocol.
module ActivityPub
  extend ActiveSupport::Autoload

  ACTIVITYSTREAMS_NAMESPACE = 'https://www.w3.org/ns/activitystreams'
  W3ID_NAMESPACE = 'https://w3id.org/security/v1'

  autoload :Actor
  autoload :Activity
  autoload :Message
  autoload :Broadcast
  autoload :Signature

  # Deliver a +Message+ to the given +:to+ host.
  #
  # @param [ActivityPub::Message] message - Message to deliver
  # @param [String] to - Host to send to
  def self.deliver(message, to:)
    Broadcast.new(message: message, destination: to).tap(&:deliver)
  end
end
