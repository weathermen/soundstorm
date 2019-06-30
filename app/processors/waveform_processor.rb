# frozen_string_literal: true

# Create a waveform image from an uploaded Track.
class WaveformProcessor < Processor
  IMAGE_TYPE = 'png'

  # Convert the audio file to WAV if it isn't already, then generate the
  # waveform image from the converted audio.
  #
  # @return [Boolean] Whether the operation was successful.
  def save
    convert && generate && persist
  end

  # @return [String] Path to the WAV file created by conversion.
  def wav_path
    "#{audio_path}.wav"
  end

  # @return [String] Audio file extension.
  def extension
    File.extname(audio_path)
  end

  # @return [String] Path to the waveform image
  def image_path
    audio_path.gsub(extension, IMAGE_TYPE)
  end

  # @return [String] Filename of the waveform image
  def name
    File.basename(image_path)
  end

  # @return [File] Generated image file
  def io
    File.open(image_path)
  end

  private

  # Convert the audio file to WAV if it isn't already.
  #
  # @private
  # @return [Boolean] Whether the operation was successful.
  def convert
    return true if File.exist?(wav_path)
    `ffmpeg -loglevel panic -i #{audio_path} #{wav_path}`
    $?.success? && File.exist?(wav_path)
  end

  # Generate a waveform image from the audio.
  #
  # @private
  # @return [Boolean] Whether an image was created.
  def generate
    Waveform.generate(wav_path, image_path, force: true)
    File.exist?(image_path)
  end

  # Upload the waveform image to ActiveStorage
  #
  # @return [Boolean] Whether an image was uploaded.
  def persist
    track.waveform.attach(io: io, filename: name)
    track.waveform.attached?
  end
end
