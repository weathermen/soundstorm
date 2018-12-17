# frozen_string_literal: true

require 'test_helper'

class ProcessTrackJobTest < ActiveJob::TestCase
  test 'post-process track audio' do
    ProcessTrackJob.perform_now(track)

    assert track.waveform.attached?
    assert track.segments.attached?
  end
end
