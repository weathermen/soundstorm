# Authentication object for the application. Also holds personal details
# like display name and private key information for identifying over
# ActivityPub/Webfinger.
class User < ApplicationRecord
  # Generate 2048-bit keys
  KEY_LENGTH = 2048

  # Use the `des-ede3-cbc` cipher
  KEY_CIPHER = 'des3'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable #, :omniauthable

  before_validation :generate_key, if: :encrypted_password_changed?
  before_validation :ensure_host, on: :create

  has_many :tracks
  has_many :follower_follows, class_name: 'Follow', as: :follower
  has_many :following_follows, class_name: 'Follow', as: :following
  has_many :followers, class_name: 'User', through: :follower_follows
  has_many :following, class_name: 'User', through: :following_follows

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

  # Create a new +User+ record from an actor object.
  def self.from_actor(actor)
    find_or_create_by!(
      name: actor.name,
      host: actor.host,
      password: SecureRandom.hex + 'A1!'
    )
  end

  def follow(user)
    following_follows.create(follower: user)
  end

  def unfollow(user)
    following_follows.find_by(follower: user).destroy
  end

  # External ActivityPub ID for this User.
  #
  # @return [String] +username@domain.host+
  def handle
    "#{name}@#{Rails.configuration.host}"
  end

  # ActivityPub representation of this User.
  def actor
    ActivityPub::Actor.new(
      name: name,
      host: Rails.configuration.host,
      key: key_pem,
      secret: encrypted_password
    )
  end

  private

  # Generate a private key for this +User+ when created or when the
  # password changes.
  #
  # @private
  def generate_key
    self.key_pem = OpenSSL::PKey::RSA.new(KEY_LENGTH)
                                     .to_pem(cipher, encrypted_password)
  end

  def generate_resource
    self.resource = "acct:#{handle}"
  end

  def cipher
    @cipher ||= OpenSSL::Cipher.new(KEY_CIPHER)
  end

  def ensure_host
    self.host ||= Rails.configuration.host
  end
end
