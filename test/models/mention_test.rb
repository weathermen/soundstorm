# frozen_string_literal: true

require 'test_helper'

class MentionTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'send email to notify user' do
    user = users(:one)
    comment = comments(:one_untitled_praise)

    assert_difference -> { ActionMailer::Base.deliveries.size } do
      perform_enqueued_jobs do
        assert comment.mention!(user)
      end
    end
  end
end
