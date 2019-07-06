# frozen_string_literal: true

require 'test_helper'

class BroadcastMessageJobTest < ActiveJob::TestCase
  test 'broadcast activitypub message when changes occur' do
    user = users(:one)
    track = tracks(:one_untitled)
    version = PaperTrail::Version.create!(
      whodunnit: user,
      item: track,
      event: 'create'
    )

    assert_enqueued_jobs 1, only: BroadcastMessageJob
    refute version.broadcasted?
    assert BroadcastMessageJob.perform_now(version)
    assert version.broadcasted?
  end
end
