# frozen_string_literal: true

class Like < Socialization::ActiveRecordStores::Like
  after_create :notify_author

  private

  def notify_author
    # NotificationMailer.like(liker, likeable).deliver_later
  end
end
