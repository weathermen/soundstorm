# frozen_string_literal: true

class Track::Analysis
  attr_reader :track, :audio, :duration, :name

  delegate :path, to: :audio

  def initialize(track:, audio:)
    @track = track
    @audio = audio
    @name = File.basename(path, 'mp3')
  end

  def self.create(track, audio)
    new(
      track: track,
      audio: audio
    ).tap(&:save)
  end

  def save
    analyze && generate_stream
  end

  private

  def analyze
    time = Time.parse(
      `ffmpeg -i #{path} 2>&1 | grep Duration | awk '{print $2}' | tr -d ,`
    )
    @duration = time.hour * 60 * 60 + time.min * 60 + time.sec

    track.update(duration: duration)
  end

  def generate_stream
    `ffmpeg -i #{path} -f segment -segment_time 3 -c copy /tmp/#{name}-%03d.mp3`

    Dir["/tmp/#{name}-*.mp3"].each do |segment_path|
      track.segments.attach(
        io: File.open(segment_path),
        filename: File.basename(segment_path)
      )
    end

    track.segments.attached?
  end
end
