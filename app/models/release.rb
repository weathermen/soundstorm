# frozen_string_literal: true

class Release < ApplicationRecord
  extend FriendlyId

  belongs_to :user

  has_many :released_tracks, dependent: :destroy
  has_many :tracks, through: :released_tracks, dependent: :destroy

  accepts_nested_attributes_for :released_tracks, allow_destroy: true

  friendly_id :name, use: %i[slugged finders]

  validates :name, presence: true, uniqueness: { scope: :user }

  acts_as_likeable

  def artist
    user.display_name
  end

  def tracks_by_number
    released_tracks.order(:number).map(&:track)
  end
end
