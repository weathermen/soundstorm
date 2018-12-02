# frozen_string_literal: true

class GenerateWaveformJob < ApplicationJob
  include ActiveStorage::Downloading

  attr_reader :blob

  queue_as :default

  def perform(track)
    @blob = track.audio

    download_blob_to_tempfile do |audio|
      filename = "#{track.id}-waveform.png"
      waveform = Tempfile.new(filename)
      audio_path = audio.path

      convert(audio_path) &&
        generate(audio_path, waveform.path) &&
        attach(track, waveform, filename)
    end
  end

  def convert(audio_path)
    Rails.logger.debug('Converting audio file to WAV')
    `ffmpeg -loglevel panic -i #{audio_path} #{audio_path}.wav`
    File.exist?("#{audio_path}.wav")
  end

  def attach(track, waveform, filename)
    Rails.logger.debug('Attaching waveform image to track')
    track.waveform.attach(io: waveform, filename: filename)
    track.waveform.attached?
  end

  def generate(audio_path, waveform_path)
    Rails.logger.debug('Generating waveform image')
    Waveform.generate("#{audio_path}.wav", waveform_path, force: true)
    File.exist?(waveform_path)
  end

  def cleanup(waveform)
    true # waveform.delete
  end
end
