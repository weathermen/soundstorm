# frozen_string_literal: true

# Create a waveform image from an uploaded +Track+.
class WaveformProcessor < Processor
  IMAGE_TYPE = 'png'

  def save
    convert && generate && persist
  end

  def wav_path
    "#{audio_path}.wav"
  end

  def extension
    File.extname(audio_path)
  end

  def image_path
    audio_path.gsub(extension, IMAGE_TYPE)
  end

  def name
    File.basename(image_path)
  end

  def io
    File.open(image_path)
  end

  private

  def convert
    `ffmpeg -loglevel panic -i #{audio_path} #{wav_path}`
    $?.success? && File.exist?(wav_path)
  end

  def generate
    Waveform.generate(wav_path, image_path, force: true)
    File.exist?(image_path)
  end

  def persist
    track.waveform.attach(io: io, filename: name)
    track.waveform.attached?
  end
end
