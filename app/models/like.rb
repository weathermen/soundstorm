class Like < ApplicationRecord
  belongs_to :user
  belongs_to :track, counter_cache: true

  def activity_id
    Rails.application.routes.url_helpers.user_like_url(
      user, self, host: user.host
    )
  end

  def as_activity
    super.merge(
      object: track.activity_id
    )
  end
end
