require 'test_helper'

class ActivityUpdateTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @track = @user.tracks.first
    @activity = ActivityPub::Activity.new(**@track.as_activity)
    @update = ActivityUpdate.new(@user, @activity)
  end

  test 'model' do
    assert_equal Track, @update.model
  end

  test 'item' do
    assert_equal @track, @update.item
  end

  test 'metadata' do
    assert_equal @activity.ip, @update.metadata[:ip]
    assert_equal @activity.payload, @update.metadata[:activity]
  end

  test 'attributes' do
    assert @update[:remote]
    assert_equal @update.item, @update[:item]
    assert_equal @update.event, @update[:event]
    assert_equal @update.event, @update[:event]
  end
end
