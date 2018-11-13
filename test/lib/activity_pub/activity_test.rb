require 'test_helper'

module ActivityPub
  class ActivityTest < ActiveSupport::TestCase
    setup do
      @user = users(:one)
      @track = @user.tracks.first
      @url = "https://test.host/#{@user.name}/#{@track.name.parameterize}"
      @activity = Activity.new(
        id: @url,
        type: 'Create',
        actor: @user.as_actor,
        payload: @track.as_activity
      )
    end

    test 'author' do
      assert_equal @user.to_global_id, @activity.author
    end

    test 'attributes' do
      assert_equal @activity.id, @activity.attributes[:id]
      assert_equal @activity.type, @activity.attributes[:type]
      assert_equal @activity.author, @activity.attributes[:author]
      assert_equal @activity.payload, @activity.attributes[:object]
    end

    test 'model' do
      refute_nil @activity.model
      assert_kind_of Track, @activity.model
      assert_equal @activity.payload[:name], @activity.model.name
    end
  end
end
