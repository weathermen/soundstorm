# frozen_string_literal: true

require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'sends email when track is liked' do
    track = tracks(:one_untitled)
    user = users(:two)

    assert_difference -> { ActionMailer::Base.deliveries.size } do
      perform_enqueued_jobs do
        assert user.like!(track)
      end
    end
  end
end
