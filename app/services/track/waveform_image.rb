# frozen_string_literal: true

class Track::WaveformImage
  attr_reader :track, :audio, :name, :file

  delegate :path, to: :audio, prefix: true
  delegate :path, to: :file

  def initialize(track:, audio:)
    @track = track
    @audio = audio
    @name = "#{track.id}-waveform.png"
    @file = Tempfile.new(name)
  end

  def self.create(track, audio)
    new(
      track: track,
      audio: audio
    ).tap(&:save)
  end

  def save
    convert && generate && persist
  end

  def wav_path
    "#{path}.wav"
  end

  def io
    File.open(path)
  end

  private

  def convert
    `ffmpeg -loglevel panic -i #{audio_path} #{wav_path}`
    File.exist?(wav_path)
  end

  def generate
    Waveform.generate(wav_path, path, force: true)
    File.exist?(path)
  end

  def persist
    track.waveform.attach(io: io, filename: name)
    track.waveform.attached?
  end
end
