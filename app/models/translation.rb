# frozen_string_literal: true

class Translation < ApplicationRecord
  def self.find_by_slug(slug)
    key = Base64.decode64(slug)

    find_by(key: key)
  end

  def slug
    Base64.encode64(key)
  end
end
