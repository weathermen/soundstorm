# frozen_string_literal: true

class Mention < Socialization::ActiveRecordStores::Mention
  # Prefix for usernames to be mentioned in comments.
  PREFIX = '@'

  # Regular expression that removes the prefix from a username.
  DEFIX = /\A#{PREFIX}/o

  # Regular expression for parsing mentions out of text.
  SYNTAX = /#{PREFIX}\w+/o

  after_create :notify_mentioned_user

  private

  def notify_mentioned_user
    NotificationMailer.mention(mentioner, mentionable).deliver_later
  end
end
