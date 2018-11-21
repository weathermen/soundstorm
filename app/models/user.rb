# Authentication object for the application. Also holds personal details
# like display name and private key information for identifying over
# ActivityPub/Webfinger.
class User < ApplicationRecord
  extend FriendlyId

  include Federatable

  # Generate 2048-bit keys
  KEY_LENGTH = 2048

  # Use the `des-ede3-cbc` cipher
  KEY_CIPHER = 'des3'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable #, :omniauthable

  has_many :tracks
  has_many :follower_follows, class_name: 'Follow', as: :follower
  has_many :following_follows, class_name: 'Follow', as: :following
  has_many :followers, class_name: 'User', through: :follower_follows
  has_many :following, class_name: 'User', through: :following_follows
  has_many :likes
  has_many :liked_tracks, through: :likes, as: :track, class_name: 'Track'

  delegate :id, to: :actor, prefix: true
  delegate :as_webfinger, to: :actor

  friendly_id :name, use: %i[slugged finders]

  before_validation :generate_key, if: :encrypted_password_changed?
  before_validation :ensure_host

  validates :name, presence: true, uniqueness: true
  validates :host, presence: true
  validates :display_name, presence: true
  validates :key_pem, presence: true, uniqueness: true

  # Find a given +User+ record by its Webfinger resource string, and
  # throw an exception when the User cannot be found.
  #
  # @throws [ResourceNotFound] when User cannot be found.
  # @return [User] from resource string.
  def self.find_by_resource!(resource)
    find_by_resource(resource) || raise(User::ResourceNotFound, resource)
  end

  # Find a given +User+ record by its Webfinger resource string. Does
  # not attempt to find users that are not from the local server.
  #
  # @return [User] or +nil+ if it cannot be found.
  def self.find_by_resource(resource)
    name, host = resource.gsub(/acct:/, '').split('@')

    find_by(name: name, host: host)
  end

  # Create a new +User+ record from an actor ID.
  #
  # @return [User]
  def self.find_or_create_by_actor_id(actor_id)
    actor = ActivityPub::Actor.find(actor_id)

    find_or_create_by(name: actor.name, host: actor.host) do |user|
      user.password = SecureRandom.hex
      user.display_name = actor.summary
      user.confirmed_at = Time.current
      user.save!
    end
  end

  # Follow a given +User+
  #
  # @param [User] user - User to follow
  # @return [Follow]
  def follow(user)
    following_follows.create(follower: user)
  end

  # Unfollow a given +User+.
  #
  # @param [User] user - User to unfollow
  # @return [Boolean]
  def unfollow(user)
    following_follows.find_by(follower: user).destroy
  end

  # Test if a +User+ is following this user.
  #
  # @param [User] user - Following user
  # @return [Boolean]
  def following?(user)
    following.include?(user)
  end

  # External ActivityPub ID for this User.
  #
  # @return [String] +username@domain.host+
  def handle
    "#{name}@#{Rails.configuration.host}"
  end

  # ActivityPub representation of this User.
  def actor
    ActivityPub::Actor.new(as_actor)
  end

  def activity_id
    Rails.application.routes.url_helpers.user_url(self, host: host)
  end

  def email_required?
    host == Rails.configuration.host
  end

  # Express the attributes for an +ActivityPub::Actor+ for rehydrating.
  def as_actor
    {
      name: name,
      summary: display_name,
      host: host,
      key: key_pem,
      secret: encrypted_password
    }
  end

  # Express activity related to this user as a "Profile" object.
  #
  # @return [Hash]
  def as_activity
    super.merge(
      type: 'Profile',
      summary: display_name,
      describes: {
        type: 'Person',
        name: name
      }
    )
  end

  # Send email notifications with ActiveJob.
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  # Generate a private key for this +User+ when created or when the
  # password changes. Uses +User::KEY_LENGTH+ to determine length.
  #
  # @private
  def generate_key
    self.key_pem = OpenSSL::PKey::RSA.new(KEY_LENGTH)
                                     .to_pem(cipher, encrypted_password)
  end

  # Cipher used to generate RSA keys, configured by +User::KEY_CIPHER+.
  #
  # @private
  # @return [OpenSSL::Cipher]
  def cipher
    @cipher ||= OpenSSL::Cipher.new(KEY_CIPHER)
  end

  # Ensure +:host+ is set to the configured host if not previously set.
  #
  # @private
  def ensure_host
    self.host = Rails.configuration.host if host.blank?
  end
end
