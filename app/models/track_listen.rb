# frozen_string_literal: true

class TrackListen < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :track, counter_cache: :listens_count

  validates :ip_address, presence: true, uniqueness: { scope: %i[track user] }

  after_create :update_track_count

  private

  def update_track_count
    ActionCable.server.broadcast(
      "track_#{track.id}",
      listens: track.listens.count
    )
  end
end
