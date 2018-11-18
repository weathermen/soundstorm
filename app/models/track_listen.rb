class TrackListen < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :track, counter_cache: :listens_count

  validates :ip_address, presence: true
  validate :client_unique

  private

  def client_unique
    user_listened = track.listens.where(user: user).any?
    ip_listened = track.listens.where(ip_address: ip_address).any?

    errors.add(:user, 'is not unique') if user_listened
    errors.add(:ip_address, 'is not unique') if ip_listened
  end
end
