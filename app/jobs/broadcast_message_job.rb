# Deliver +ActivityPub+ notifications to all followers of a given user.
class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(version)
    version.followers.all? do |follower|
      ActivityPub.deliver(version.message, to: follower.host).success?
    end
  end
end
