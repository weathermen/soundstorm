# frozen_string_literal: true

require 'open-uri'

class Track < ApplicationRecord
  include Federatable
  include Searchable

  extend FriendlyId

  STREAM_SEGMENT_DURATION = 3

  belongs_to :user, counter_cache: true

  has_one_attached :audio
  has_one_attached :waveform

  has_many_attached :segments

  has_many :listens, class_name: 'TrackListen', dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one :released_track, dependent: :destroy
  has_one :release, through: :released_track

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :audio, presence: true # , #content_type: %w(audio/mpeg), \
  # if: -> { audio.attached? }

  acts_as_likeable

  friendly_id :name, use: %i[slugged finders]

  after_save :process, unless: :processed?

  delegate :name, to: :user, prefix: true
  delegate :number, to: :released_track, allow_nil: true

  attr_writer :username, :artist

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name
      indexes :artist
    end
  end

  def as_indexed_json(options = {})
    as_json.merge(
      username: user.name,
      artist: artist
    )
  end

  def artist
    user.display_name
  end

  def duration
    audio.blob.metadata[:duration] if audio.attached?
  end

  def title
    "#{user.display_name} - #{name}"
  end

  def filename
    "#{title}.mp3"
  end

  def formatted_duration
    return '00:00' if duration.blank?
    Time.at(duration).utc.strftime('%M:%S')
  end

  def audio_url
    Rails.application.routes.url_helpers.rails_blob_url(audio, host: user.host)
  end

  def stream_url
    Rails.application.routes.url_helpers.user_track_url(user, self, host: user.host, format: :m3u8)
  end

  # Attach audio from ActivityPub URL download.
  def url=(href:, **params)
    open(href) do |file|
      filename = File.basename(href)


      audio.attach(
        io: file,
        filename: filename,
        content_type: params[:mediaType]
      )
    end
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
        href: stream_url,
        mediaType: audio.content_type
      }
    )
  end

  def processed?
    waveform.attached? && segments.attached?
  end

  private

  # Post-process Track audio in the background.
  #
  # @private
  def process
    ProcessTrackJob.perform_later(self)
  end
end
