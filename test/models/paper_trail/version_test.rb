# frozen_string_literal: true

require 'test_helper'

module PaperTrail
  class VersionTest < ActiveSupport::TestCase
    setup do
      @user = users(:one)
      @track = tracks(:one_untitled)
      mp3 = ::Rails.root.join('test', 'fixtures', 'files', 'one.mp3')
      @track.audio.attach(io: mp3.open, filename: mp3.basename)
      @create = PaperTrail::Version.create!(
        whodunnit: @user,
        item: @track,
        event: 'create'
      )
      @update = PaperTrail::Version.create!(
        whodunnit: @user,
        item: @track,
        event: 'update'
      )
    end

    test 'remote followers' do
      remote = users(:remote)

      remote.follow! @user

      assert_includes(@create.followers, remote)
      assert_includes(@create.remote_followers, remote)
    end

    test 'user' do
      assert_equal(@user, @create.user)
    end

    test 'upload?' do
      assert(@create.upload?)
      refute(@update.upload?)
    end

    test 'verb' do
      assert_equal('uploaded', @create.verb)
      assert_equal('updated', @update.verb)
    end

    test 'type' do
      assert_equal('Create', @create.type)
      assert_equal('Update', @update.type)
    end

    test 'message' do
      assert_equal(@create.activity_id, @create.message.id)
      assert_equal(@create.type, @create.message.type)
      assert_equal(@create.created_at, @create.message.published)
      assert_equal(@create.actor.id, @create.message.actor.id)
      assert_equal(@create.as_activity, @create.message.payload)
    end

    test 'broadcasted?' do
      refute(@create.broadcasted?)

      @create.update!(broadcasted_at: Time.current)

      assert(@create.broadcasted?)
    end
  end
end
