require 'test_helper'

module ActivityPub
  class ActivityTest < ActiveSupport::TestCase
    setup do
      @user = users(:one)
      @user.update!(
        key_pem: Rails.root.join('test', 'fixtures', 'files', 'one.pem').read
      )
      @track = @user.tracks.first
      @file = Rails.root.join('test', 'fixtures', 'files', 'one.mp3')
      @track.audio.attach(io: File.open(@file), filename: @file.basename)
      @url = "https://test.host/#{@user.name}/#{@track.name.parameterize}"
      @activity = Activity.new(
        id: @url,
        type: 'Create',
        actor: @user.as_actor,
        object: @track.as_activity
      )
    end

    test 'attributes' do
      assert_equal @activity.id, @activity.attributes[:id]
      assert_equal @activity.type, @activity.attributes[:type]
      assert_equal @activity.actor.id, @activity.attributes[:actor]
      assert_equal @activity.payload, @activity.attributes[:object]
    end
  end
end
