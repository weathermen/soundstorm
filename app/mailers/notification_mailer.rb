# frozen_string_literal: true

# Send email notifications to users.
class NotificationMailer < ApplicationMailer
  # Sent when a user mentions another user in a comment.
  #
  # @param [Comment] comment - Posted comment
  # @param [User] user - User who was mentioned
  def mention(comment, user)
    @comment = comment
    @user = user
    @subject = t('.subject', user: @comment.user.name)

    mail to: @user.email, subject: @subject
  end

  # Sent when a user likes someone else's track.
  #
  # @param [User] user - User who liked the track
  # @param [Track] track - Track that was liked
  def like(user, track)
    @user = user
    @track = track
    @subject = t('.subject', user: @user.name, track: @track.name)

    mail to: @track.user.email, subject: @subject
  end

  # Sent when a user replies to another user's comment.
  #
  # @param [Comment] comment - Posted comment
  # @param [User] user - User that was replied to
  def reply(comment, user)
    @comment = comment
    @user = user
    @track = @comment.track
    @subject = t('.subject', user: @comment.user.name, track: @track.name)

    mail to: @user.email, subject: @subject
  end
end
