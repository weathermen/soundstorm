# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/mention
  def mention
    NotificationMailer.mention
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/like
  def like
    NotificationMailer.like
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/reply
  def reply
    NotificationMailer.reply
  end

end
