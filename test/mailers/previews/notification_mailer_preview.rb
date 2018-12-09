# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/mention
  def mention
    comment = Comment.first
    user = User.first

    NotificationMailer.mention(comment, user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/like
  def like
    user = User.first
    track = Track.first

    NotificationMailer.like(user, track)
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/reply
  def reply
    comment = Comment.replies.first
    user = User.first

    NotificationMailer.reply(comment, user)
  end
end
