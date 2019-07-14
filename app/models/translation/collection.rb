# frozen_string_literal: true

class Translation::Collection
  include Enumerable

  def initialize(translations = [])
    @translations = flatten_hash(translations).sort
  end

  def each
    @translations.each do |*translation|
      yield Translation.get(*translation)
    end
  end

  private

  def flatten_hash(hash, results = {}, parent_key = '')
    return results unless hash.kind_of?(Hash)

    hash.keys.each do |key|
      current_key = parent_key.blank? ? key : "#{parent_key}.#{key}"

      if hash[key].kind_of?(Hash)
        results = flatten_hash(hash[key], results, current_key)
      else
        results[current_key] = hash[key]
      end
    end

    results
  end
end
