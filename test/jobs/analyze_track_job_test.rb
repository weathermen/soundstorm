# frozen_string_literal: true

require 'test_helper'

class AnalyzeTrackJobTest < ActiveJob::TestCase
  test 'generate waveform from track audio and find duration' do
    user = users(:one)
    track = user.tracks.build(
      name: 'audio one',
      description: 'foo'
    )
    track.audio.attach(
      io: Rails.root.join('test', 'fixtures', 'files', 'one.mp3').open,
      filename: 'one.mp3'
    )
    track.save!

    AnalyzeTrackJob.perform_now(track)

    assert track.waveform.attached?
    assert_equal 42, track.duration
  end
end
