# frozen_string_literal: true

class Track < ApplicationRecord
  include Commentable
  include Federatable
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  extend FriendlyId

  STREAM_SEGMENT_DURATION = 3

  index_name "soundstorm_#{Rails.env}"

  belongs_to :user, counter_cache: true

  has_one_attached :audio
  has_one_attached :waveform

  has_many_attached :segments

  has_many :listens, class_name: 'TrackListen', dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :audio, presence: true, content_type: %w(audio/mpeg)

  acts_as_likeable

  friendly_id :name, use: %i[slugged finders]

  after_create :analyze

  delegate :name, to: :user, prefix: true

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name
      indexes :user_name, analyzer: 'english'
    end
  end

  def filename
    "#{user.display_name} - #{name}.mp3"
  end

  def formatted_duration
    return '00:00' if duration.blank?
    Time.at(duration).utc.strftime('%M:%S')
  end

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

  private

  def analyze
    AnalyzeTrackJob.perform_later(self)
  end
end
