# frozen_string_literal: true

class ReleasedTrack < ApplicationRecord
  belongs_to :track
  belongs_to :release

  scope :by_number, -> { order(:number) }

  accepts_nested_attributes_for :track, update_only: true

  before_create :populate_track_user

  def populate_track_user
    track.user = release.user
  end
end
