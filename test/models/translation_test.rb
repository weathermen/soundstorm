# frozen_string_literal: true

require 'test_helper'

class TranslationTest < ActiveSupport::TestCase
  setup do
    @translation = Translation.create!(
      key: 'foo.bar',
      value: 'baz'
    )
  end

  test 'slug' do
    assert_equal Base64.encode64(@translation.key), @translation.slug
  end

  test 'find by slug' do
    assert_equal @translation, Translation.find_by_slug(@translation.slug)
  end

  test 'get' do
    new_translation = Translation.get('foo.bat', 'bar')

    assert_equal 'bar', new_translation.value
    assert new_translation.save!
  end
end
