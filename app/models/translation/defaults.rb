# frozen_string_literal: true

class Translation::Defaults
  include Enumerable

  attr_reader :locale, :path, :data

  def initialize(locale)
    @translations = I18n.t('*')
  end

  def each
    data.each do |key, value|
      if value.is_a? Hash
    end
  end

  private

  def data
    @data ||= YAML.load_file(path)
  end
end
