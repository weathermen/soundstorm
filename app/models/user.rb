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

  acts_as_follower
  acts_as_followable

  has_one_attached :avatar

  has_many :tracks
  has_many :follows, as: :follower
  has_many :likes
  has_many :liked_tracks, through: :likes, source: :track
  has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all

  has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all

  delegate :as_webfinger, to: :actor

  friendly_id :name, use: %i[slugged finders]

  before_validation :generate_key, if: :encrypted_password_changed?
  before_validation :ensure_host
  before_validation :ensure_display_name

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

  # All activity by users this user follows.
  #
  # @return [ActiveRecord::Relation]
  def activities
    PaperTrail::Version.where(whodunnit: followings.map(&:to_global_id))
  end

  def to_param
    name
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

  # Ensure +:host+ is set to the local host if blank. Blank hosts mean
  # the user was created locally, and thus should be assigned the local
  # host in the DB.
  #
  # @private
  def ensure_host
    self.host = Rails.configuration.host if host.blank?
  end

  # Set the +display_name+ to the user's +name+ if not explicitly set.
  #
  # @private
  def ensure_display_name
    self.display_name ||= name
  end
end
