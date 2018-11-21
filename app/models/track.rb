class Track < ApplicationRecord
  include Commentable
  include Federatable

  extend FriendlyId

  belongs_to :user

  has_one_attached :audio
  has_many :listens, class_name: 'TrackListen', dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :audio, presence: true

  friendly_id :name, use: %i[slugged finders]

  def audio_url
    Rails.application.routes.url_helpers.rails_blob_path(audio, host: user.host)
  end

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
        href: audio_url,
        mediaType: audio.content_type
      }
    )
  end
end
