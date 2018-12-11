# frozen_string_literal: true

require 'open3'

class Track::Analysis
  attr_reader :track, :audio, :duration, :name, :tmp_path

  delegate :path, to: :audio
  delegate :logger, to: Rails

  def initialize(track:, audio:)
    @track = track
    @audio = audio
    @name = File.basename(path, '.mp3')
    @tmp_path = Pathname.new("/tmp/#{name}")
  end

  def self.create(track, audio)
    new(
      track: track,
      audio: audio
    ).tap(&:save)
  end

  def save
    analyze && segmentize
  end

  private

  def analyze
    time = Time.parse(
      `ffmpeg -i #{path} 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`
    )
    @duration = time.hour * 60 * 60 + time.min * 60 + time.sec

    track.update(duration: duration)
  end

  def segmentize
    tmp_path.mkdir && create_segments && attach_segments && FileUtils.rm_rf(tmp_path)
  end

  def create_segments
    Open3.popen3(ffmpeg_command.join(' ')) do |stdin, stdout, stderr, thread|
      logger.tagged("ffmpeg #{thread.pid}") do
        output = stdout.read.chomp
        errors = stderr.read.chomp

        logger.debug(output)
        logger.error(errors) if errors.present?
      end
    end

    tmp_path.entries.any?
  end

  def attach_segments
    Dir[tmp_path.join('*.ts')].sort.each do |segment_path|
      track.segments.attach(
        io: File.open(segment_path),
        filename: File.basename(segment_path)
      )
    end

    track.segments.attached?
  end

  def ffmpeg_command
    [
      'ffmpeg',
      "-i #{path}",
      '-f segment',
      "-segment_time #{Track::STREAM_SEGMENT_DURATION}",
      "-c copy #{tmp_path}/%03d.ts"
    ]
  end
end
