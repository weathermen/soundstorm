# frozen_string_literal: true

class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.mentioned.subject
  #
  def mentioned(_comment, user)
    @user = user
    @subject = t(
      :subject,
      scope: %i[user_mailer mentioned],
      author: @comment.user.name
    )

    mail to: user.email, subject: @subject
  end
end
