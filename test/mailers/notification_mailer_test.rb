require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "mention" do
    mail = NotificationMailer.mention
    assert_equal "Mention", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "like" do
    mail = NotificationMailer.like
    assert_equal "Like", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "reply" do
    mail = NotificationMailer.reply
    assert_equal "Reply", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
