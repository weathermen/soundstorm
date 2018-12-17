# frozen_string_literal: true

# Base class for all processors.
class Processor
  attr_reader :track, :audio

  delegate :path, to: :audio, prefix: true
  delegate :logger, to: Rails

  def initialize(track:, audio:)
    @track = track
    @audio = audio
  end

  def self.process(track, audio)
    new(track: track, audio: audio).tap(&:save!)
  end

  def self.each
    ObjectSpace.each_object(self) { |processor| yield processor }
  end

  def save
    raise NotImplementedError, "#{self.class.name} must implement #save"
  end

  def save!
    save || raise(ProcessError)
  end
end
