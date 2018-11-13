class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :commentable, polymorphic: true

  has_paper_trail

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
end
