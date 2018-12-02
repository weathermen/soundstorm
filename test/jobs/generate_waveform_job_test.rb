# frozen_string_literal: true

require 'test_helper'

class GenerateWaveformJobTest < ActiveJob::TestCase
  test 'generate waveform from track audio' do
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

    GenerateWaveformJob.perform_now(track)

    assert track.waveform.attached?
  end
end
