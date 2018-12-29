# frozen_string_literal: true

require 'test_helper'

class ActivityUpdateTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @track = @user.tracks.first
    audio = Rails.root.join('test', 'fixtures', 'files', 'one.mp3')
    @track.audio.attach(
      io: File.open(audio),
      filename: 'one.mp3',
      content_type: 'audio/mpeg'
    )
    @activity = ActivityPub::Activity.new(
      id: @track.activity_id,
      type: 'Create',
      actor: @user.actor,
      object: @track.as_activity,
      host: @user.host
    )
    @update = ActivityUpdate.new(user: @user, activity: @activity)
  end

  test 'model' do
    assert_equal Track, @update.model
  end

  test 'item' do
    skip 'Need to mock out request for CI'

    assert_equal @track, @update.item
  end

  test 'metadata' do
    assert_equal @activity.payload, @update.metadata[:activity]
  end

  test 'attributes' do
    skip 'Need to mock out request for CI'

    assert @update[:remote]
    assert_equal @update.item, @update[:item]
    assert_equal @update.event, @update[:event]
    assert_equal @user.to_global_id, @update[:whodunnit]
    assert_equal @update.metadata, @update[:object]
  end
end
