class Track < ApplicationRecord
  include Commentable

  extend FriendlyId

  belongs_to :user

  has_one_attached :audio

  delegate_missing_to :audio

  validates :name, presence: true, uniqueness: { scope: :user }

  friendly_id :name, use: %i[slugged finders]
end
