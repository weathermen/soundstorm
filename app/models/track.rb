class Track < ApplicationRecord
  include Commentable
  include Federatable

  extend FriendlyId

  belongs_to :user

  has_one_attached :audio

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :audio, presence: true

  friendly_id :name, use: %i[slugged finders]

  def activity_id
    Rails.application.routes.url_helpers.user_track_url(user, self, host: user.host)
  end

  # Represent this object as an "Audio" type in activity feeds.
  #
  # @return [Hash]
  def as_activity
    super.merge(
      type: 'Audio',
      name: name,
      url: {
        type: 'Link',
        href: audio.url,
        mediaType: audio.type
      }
    )
  end
end
