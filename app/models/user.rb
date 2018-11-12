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

  has_many :tracks

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :key_pem, presence: true, uniqueness: true

  # @!method
  #   ActivityPub Public Key for this User, generated from the private
  #   key.
  #
  #   @return [OpenSSL::PKey::RSA]
  delegate :public_key, to: :private_key

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
    handle = resource.gsub(/acct:/, '')
    name, host = handle.split('@')

    return unless host == Rails.configuration.host

    find_by(name: name)
  end

  # External ActivityPub ID for this User.
  #
  # @return [String] +username@domain.host+
  def handle
    "#{name}@#{Rails.configuration.host}"
  end

  # ActivityPub Private Key for this User.
  #
  # @return [OpenSSL::PKey::RSA]
  def private_key
    OpenSSL::PKey::RSA.new(key_pem, encrypted_password)
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
end
