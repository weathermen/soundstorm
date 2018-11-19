# Deliver +ActivityPub+ notifications to all followers of a given user.
class BroadcastMessageJob < ApplicationJob
  queue_as :federation

  def perform(version)
    version.followers.each do |follower|
      ActivityPub.deliver(version.message, to: follower.host)
    end
  end
end
