# frozen_string_literal: true

require 'test_helper'

class Translation::CollectionTest < ActiveSupport::TestCase
  setup do
    @collection = Translation::Collection.new(I18n.t('.'))
  end

  test 'flatten i18n hash' do
    nested_hash = {
      foo: {
        bar: {
          baz: 'bat'
        }
      }
    }
    flattened_hash = @collection.send(:flatten_hash, nested_hash)

    assert flattened_hash.key?('foo.bar.baz')
    assert_equal 'bat', flattened_hash['foo.bar.baz']
  end

  test 'enumerate flattened hash into translation objects' do
    assert_kind_of Translation, @collection.first
  end
end
