# frozen_string_literal: true

# Base class for all Track processors.
class Processor
  attr_reader :track, :audio

  delegate :path, to: :audio, prefix: true
  delegate :logger, to: Rails

  # @param [Track] track - Data model representing the track
  # @param [ActiveStorage::Blob] audio - File being uploaded
  def initialize(track:, audio:)
    @track = track
    @audio = audio
  end

  # Process the given audio data and attach it to a Track
  #
  # @param [Track] track - Data model representing the track
  # @param [ActiveStorage::Blob] audio - File being uploaded
  def self.process(track, audio)
    new(track: track, audio: audio).tap(&:save!)
  end

  # @method save
  #
  # Define this method to implement what happens when this processor
  # runs.

  # Attempt to call `#save`, and throw an error if it fails.
  #
  # @return [Boolean] `true` if successful
  # @raise [ProcessError] when not successful
  def save!
    save || raise(ProcessError)
  end
end
