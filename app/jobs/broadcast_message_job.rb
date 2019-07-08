# frozen_string_literal: true

# Deliver +ActivityPub+ notifications to all followers of a given user.
class BroadcastMessageJob < ApplicationJob
  queue_as :federation

  def perform(version)
    version.remote_followers.each do |follower|
      ActivityPub.deliver(version.message, to: follower.host)
    end

    version.update!(broadcasted_at: Time.current)
  end
end
