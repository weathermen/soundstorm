# frozen_string_literal: true

require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  setup do
    @from = ['no-reply@soundstorm.test']
  end

  test 'mention' do
    user = users(:two)
    track = tracks(:one_untitled)
    comment = comments(:one_untitled_praise)
    reply = comment.children.build(
      content: "@#{track.user} hi",
      user: user,
      track: track
    )
    mail = NotificationMailer.mention(reply, track.user)

    assert_includes mail.subject, comment.user.name
    assert_equal [track.user.email], mail.to
    assert_equal @from, mail.from
    assert_includes mail.body.encoded, mail.subject
  end

  test 'like' do
    user = users(:two)
    track = tracks(:one_untitled)
    mail = NotificationMailer.like(user, track)

    assert_includes mail.subject, user.name
    assert_equal [track.user.email], mail.to
    assert_equal @from, mail.from
    assert_includes mail.body.encoded, 'has liked your track'
  end

  test 'reply' do
    user = users(:one)
    track = tracks(:one_untitled)
    comment = comments(:one_untitled_praise)
    reply = comment.children.build(content: 'test', user: user, track: track)
    mail = NotificationMailer.reply(reply, user)

    assert_equal [user.email], mail.to
    assert_equal @from, mail.from
    assert_includes mail.subject, user.name
    assert_includes mail.body.encoded, reply.content
  end
end
