# frozen_string_literal: true

class AnalyzeTrackJob < ApplicationJob
  include ActiveStorage::Downloading

  attr_reader :blob

  queue_as :default

  def perform(track)
    @blob = track.audio

    download_blob_to_tempfile do |audio|
      logger.info 'Generating waveform image from track...'
      Track::WaveformImage.create(track, audio)
      logger.info 'Analyzing track duration...'
      Track::Analysis.create(track, audio)
    end
  end
end
