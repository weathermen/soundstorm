require 'test_helper'

class BroadcastMessageJobTest < ActiveJob::TestCase
  test 'broadcast message when changes occur' do
    version = versions(:one)
    message = version.message
    host = version.whodunnit.followers.first.host

    ActivityPub.stub :deliver, message, to: host do
      assert BroadcastMessageJob.perform_now(version)
    end
  end
end
