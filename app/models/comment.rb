class Comment < ApplicationRecord
  include Federatable

  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true

  scope :roots, -> { where(parent: nil) }

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
end
