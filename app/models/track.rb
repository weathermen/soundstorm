class Track < ApplicationRecord
  include Commentable
  include Federatable

  extend FriendlyId

  belongs_to :user

  has_one_attached :audio

  validates :name, presence: true, uniqueness: { scope: :user }

  friendly_id :name, use: %i[slugged finders]

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
