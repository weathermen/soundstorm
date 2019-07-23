# frozen_string_literal: true

require 'test_helper'

class BroadcastMessageJobTest < ActiveJob::TestCase
  setup do
    @user = users(:one)
    @remote = users(:remote)
    @track = tracks(:one_untitled)
    @audio = Rails.root.join('test', 'fixtures', 'files', 'one.mp3')
    @track.audio.attach(io: @audio.open, filename: @audio.basename)
    @remote.follow!(@user)
    @version = PaperTrail::Version.new(
      whodunnit: @user.to_gid,
      item: @track,
      event: 'create'
    )
  end

  test 'change will be broadcasted' do
    refute_empty @version.remote_followers
    assert @version.broadcastable?
  end

  test 'enqueue job when version saved' do
    assert @version.save!
    refute @version.broadcasted?
    assert_enqueued_jobs 1, only: BroadcastMessageJob
  end

  test 'broadcast activitypub message' do
    VCR.use_cassette :broadcast_activitypub_message do
      perform_enqueued_jobs only: BroadcastMessageJob do
        assert @version.save!
        assert @version.reload.broadcasted?, 'Change was not broadcasted'
      end
    end
  end
end
