# frozen_string_literal: true

# After a track has been processed by ActiveStorage, perform
# post-processing tasks such as segmentization and waveform generation.
class ProcessTrackJob < ApplicationJob
  include ActiveStorage::Downloading

  attr_reader :blob

  queue_as :default

  def perform(track)
    @blob = track.audio.blob

    download_blob_to_tempfile do |audio|
      [
        WaveformProcessor,
        SegmentProcessor
      ].each do |processor|
        processor.process(track, audio)
      end
    end
  end
end
