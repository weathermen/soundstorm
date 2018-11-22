class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  def activity_id
    return unless persisted?
    Rails.application.routes.url_helpers.user_follow_url(
      follower, self, host: user.host
    )
  end

  def as_activity
    super.merge(
      actor: follower.actor_id,
      object: followed.actor_id
    )
  end
end
