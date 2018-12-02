# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.mention.subject
  #
  def mention(comment, user)
    @comment = comment
    @user = user

    mail to: @user.email, subject: t('.subject', user: @comment.user.name)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.like.subject
  #
  def like(user, track)
    @user = user
    @track = track
    @subject = t('.subject', user: @user.name, track: @track.name)

    mail to: @track.user.email, subject: @subject
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.reply.subject
  #
  def reply(comment, user)
    @comment = comment
    @user = user
    @track = @comment.track
    @subject = t('.subject', user: @comment.user.name, track: @track.name)

    mail to: @user.email, subject: @subject
  end
end
