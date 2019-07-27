# frozen_string_literal: true

# Deliver +ActivityPub+ notifications to all followers of a given user.
class BroadcastMessageJob < ApplicationJob
  queue_as :federation

  def perform(version)
    broadcasts = version.remote_followers.map do |follower|
      ActivityPub.deliver(version.message, to: follower.host)
    end

    raise 'Error: Broadcast Unsuccessful' if broadcasts.none?(&:success?)

    version.update!(broadcasted_at: Time.current)
  end
end
