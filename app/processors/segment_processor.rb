# frozen_string_literal: true

class SegmentProcessor < Processor
  delegate :mkdir, to: :tmp_path

  def save
    mkdir && create && attach && rmdir
  end

  private

  def name
    File.basename(audio_path, File.extname(audio_path))
  end

  def tmp_path
    Pathname.new("/tmp/#{name}")
  end

  def create
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

  def attach
    Dir[tmp_path.join('*.ts')].sort.each do |segment_path|
      track.segments.attach(
        io: File.open(segment_path),
        filename: File.basename(segment_path)
      )
    end

    track.segments.attached?
  end

  def rmdir
    FileUtils.rm_rf(tmp_path)
  end

  def ffmpeg_command
    [
      'ffmpeg',
      "-i #{audio_path}",
      '-f segment',
      "-segment_time #{Track::STREAM_SEGMENT_DURATION}",
      "-c copy #{tmp_path}/%03d.ts"
    ]
  end
end
