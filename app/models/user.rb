class User < ApplicationRecord
  KEY_LENGTH = 2048

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable #, :omniauthable

  before_validation :generate_key, on: :create

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :public_key_contents, presence: true, length: { equals: KEY_LENGTH }
  validates :private_key_contents, presence: true, length: { equals: KEY_LENGTH }

  delegate :public_key, to: :private_key

  def handle
    "#{name}@#{Rails.application.credentials.host}"
  end

  def private_key
    OpenSSL::PKey::RSA.new(key_pem)
  end

  private

  def generate_key
    self.key_pem = OpenSSL::PKey::RSA.new(KEY_LENGTH).to_pem(cipher, password)
  end

  def cipher
    @cipher ||= OpenSSL::Cipher::Cipher.new('des3')
  end
end
