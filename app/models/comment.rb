class Comment < ApplicationRecord
  include Federatable

  belongs_to :user
  belongs_to :track, counter_cache: true
  belongs_to :parent, class_name: 'Comment', optional: true

  acts_as_mentioner

  validates :content, presence: true

  scope :roots, -> { where(parent: nil) }

  after_create :notify_mentioned_users

  def root?
    parent.blank?
  end

  def leaf?
    children.none?
  end

  def children
    Comment.where(parent: self)
  end

  def parent_activity_id
    parent&.activity_id || commentable.activity_id
  end

  def as_activity
    super.merge(
      type: 'Note',
      inReplyTo: parent_activity_id,
      content: content
    )
  end

  def mentioned_users
    mentions(User)
  end

  private

  def notify_mentioned_users
    mentioned_users.each do |user|
      UserMailer.mentioned(self, user).deliver_later
    end
  end
end
