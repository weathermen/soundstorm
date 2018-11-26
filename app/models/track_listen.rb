# frozen_string_literal: true

class TrackListen < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :track, counter_cache: :listens_count

  validates :ip_address, presence: true, uniqueness: { scope: %i[track user] }
end
