# frozen_string_literal: true

class AudioAnalyzer < ActiveStorage::Analyzer
  def self.accept?(blob)
    blob.audio?
  end

  def metadata
    {
      duration: duration,
      bit_rate: bit_rate,
      sample_rate: sample_rate,
      codec: codec,
      channels: channels,
      channel_layout: channel_layout
    }
  end

  def duration
    stream['duration'].to_f
  end

  def bit_rate
    stream['bit_rate'].to_f
  end

  def sample_rate
    stream['sample_rate'].to_i
  end

  def codec
    stream['codec']
  end

  def channels
    stream['channels'].to_i
  end

  def channel_layout
    stream['channel_layout']
  end

  private

  def probe
    @probe ||= IO.popen(command) do |output|
      JSON.parse(output)
    end
  end

  def stream
    probe['streams'].first
  end

  def command
    [
      ffprobe,
      '-print_format json',
      '-show_streams',
      '-v error',
      file.path
    ]
  end

  def ffprobe
    ActiveStorage.paths[:ffprobe] || 'ffprobe'
  end
end
