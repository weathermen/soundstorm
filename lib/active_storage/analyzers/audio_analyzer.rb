# frozen_string_literal: true

# Uses +ffprobe+ to quickly find information about the track file, such
# as duration, bitrate, sample rate, and its codec.
module ActiveStorage
  class Analyzer::AudioAnalyzer < Analyzer
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
      }.compact
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
      @probe ||= download_blob_to_tempfile do |file|
        IO.popen(command(file.path)) do |output|
          JSON.parse(output.read)
        end
      end
    end

    def stream
      probe['streams'].first
    end

    def command(path)
      [
        ffprobe,
        '-show_streams',
        '-v',
        'error',
        '-print_format',
        'json',
        path
      ]
    end

    def ffprobe
      ActiveStorage.paths[:ffprobe] || 'ffprobe'
    end
  end
end
