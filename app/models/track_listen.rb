class TrackListen < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :track, counter_cache: true

  validates :ip_address, presence: true
  validate :client_unique

  private

  def client_unique
    user_listened = track.listens.where(user: user).any?
    ip_listened = track.listens.where(ip_address: ip_address).any?

    errors.add(:base, 'is not unique') if user_listened || ip_listened
  end
end
