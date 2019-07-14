# frozen_string_literal: true

# Database-backed copy that can be edited by admins without touching the
# codebase.
class Translation < ApplicationRecord
  # Obtain a `Translation` instance based on a base64-encoded slug used
  # in the URL to refer to a particular translation.
  #
  # @param [String] slug - Base64-encoded key
  # @return [Translation]
  def self.find_by_slug(slug)
    get Base64.decode64(slug)
  end

  # Obtain a `Translation` object based on the given key/value pair
  # or find an existing one in the database.
  #
  # @param [String] key - Reference ID for this translation in `I18n`
  # @param [String] value - (optional) The value for this translation
  # @return [Translation]
  def self.get(key, value = nil)
    find_or_initialize_by(key: key, locale: I18n.locale) do |translation|
      translation.value = value if value.present?
    end
  end

  # Base64-encoded key of this translation, used in URLs to refer to
  # this particular database record.
  #
  # @return [String]
  def slug
    Base64.encode64(key)
  end
end
