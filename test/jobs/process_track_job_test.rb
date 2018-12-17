# frozen_string_literal: true

require 'test_helper'

class ProcessTrackJobTest < ActiveJob::TestCase
  test 'post-processing' do
    track = tracks(:one_untitled)
    file = Rails.root.join('test', 'fixtures', 'files', 'one.mp3')

    track.audio.attach(io: file.open, filename: file.basename.to_s)
    ProcessTrackJob.perform_now(track)

    assert track.audio.attached?
    assert track.waveform.attached?
    assert track.segments.attached?
    assert track.processed?
  end

  test 'enqueue when audio changes' do
    track = tracks(:one_untitled)
    file = Rails.root.join('test', 'fixtures', 'files', 'one.mp3')

    track.audio.attach(io: file.open, filename: file.basename.to_s)

    assert track.save
    refute track.processed?
    assert_enqueued_jobs 1, only: ProcessTrackJob
  end
end
