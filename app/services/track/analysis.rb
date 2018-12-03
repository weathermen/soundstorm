# frozen_string_literal: true

class Track::Analysis
  attr_reader :track, :audio, :duration

  delegate :path, to: :audio

  def initialize(track:, audio:)
    @track = track
    @audio = audio
  end

  def self.create(track, audio)
    new(
      track: track,
      audio: audio
    ).tap(&:save)
  end

  def save
    analyze && persist
  end

  private

  def analyze
    time = Time.parse(
      `ffmpeg -i #{path} 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`
    )
    @duration = time.hour * 60 * 60 + time.min * 60 + time.sec
    !duration.zero?
  end

  def persist
    track.update(duration: duration)
  end
end
