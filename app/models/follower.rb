# Represents a user from any other instance (or the current one)
# that a user on this instance follows.
class Follower
  include ActiveRecord::Embedded::Model

  embedded_in :user

  field :name
  field :host

  validates :name, presence: true
  validates :host, presence: true

  def local?
    host == Rails.configuration.host
  end

  def user
    User.find_by(name: name) if local?
  end
end
