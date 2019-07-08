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
end
