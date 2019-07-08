# frozen_string_literal: true

require 'test_helper'

module PaperTrail
  class VersionTest < ActiveSupport::TestCase
    setup do
      @user = users(:one).tap do |u|
        u.follow!(remote)
      end
      @track = tracks(:one_untitled)
      @version = PaperTrail::Version.create!(
        whodunnit: @user,
        item: @track,
        event: 'create'
      )
    end

    test 'remote followers' do
      remote = users(:remote)
      @user.follow!(remote)

      assert_includes(remote, @version.followers)
      assert_includes(remote, @version.remote_followers)
    end

    test 'user' do
      assert_equal(@user, @version.user)
    end

    test 'upload?' do
      update = PaperTrail::Version.create!(
        whodunnit: @user,
        item: @track,
        action: 'update'
      )

      assert(@version.upload?)
      refute(update.upload?)
    end

    test 'verb' do
      assert_equal('created', @version.verb)
    end

    test 'type' do
      assert_equal('Create', @version.type)
    end

    test 'message' do
      assert_equal(@version.activity_id, @version.message.id)
      assert_equal(@version.type, @version.message.type)
      assert_equal(@version.created_at, @version.message.published)
      assert_equal(@version.actor, @version.message.actor)
      assert_equal(@version.as_activity, @version.message.payload)
    end

    test 'broadcasted?' do
      refute(@version.broadcasted?)

      @version.update!(broadcasted_at: Time.current)

      assert(@version.broadcasted?)
    end
  end
end
