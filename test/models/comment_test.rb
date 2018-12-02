# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'mention users' do
    track = tracks(:one_untitled)
    user = users(:two)
    comment = track.comments.create(
      user: user,
      content: "@#{track.user.name} good stuff!"
    )

    assert comment.persisted?
    refute_empty comment.mentioned_users
    assert_includes comment.mentioned_users, track.user
    assert_enqueued_jobs 1
  end

  test 'root comment has no parent' do
    track = tracks(:one_untitled)
    user = users(:two)
    comment = track.comments.create(
      user: user,
      content: 'good stuff!'
    )

    assert comment.root?
    assert comment.leaf?
    refute comment.reply?
  end

  test 'reply comments have a parent' do
    track = tracks(:one_untitled)
    user = users(:two)
    comment = track.comments.create!(
      user: user,
      content: 'good stuff!'
    )
    reply = comment.children.create!(
      user: track.user,
      track: track,
      content: 'thank you'
    )

    assert comment.root?, 'not root'
    refute comment.leaf?, 'is leaf'
    assert reply.reply?, 'not reply'
    assert reply.leaf?, 'not leaf'
  end

  test 'as activity' do
    comment = comments(:one_untitled_praise)
    private_key_pem = Rails.root.join(
      'test', 'fixtures', 'files', 'actor.pem'
    ).read
    actor = ActivityPub::Actor.new(
      name: 'lester',
      host: 'test.host',
      key: private_key_pem,
      secret: 'passphrase',
      summary: 'lester tester'
    )

    comment.user.stub(:actor, actor) do
      assert_equal comment.activity_id, comment.as_activity[:id]
      assert_equal 'Note', comment.as_activity[:type]
      assert_equal comment.parent_activity_id, comment.as_activity[:inReplyTo]
      assert_equal comment.content, comment.as_activity[:content]
    end
  end
end
