# frozen_string_literal: true

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  setup do
    @search = Search.new(query: '*')
  end

  test 'count' do
    assert_equal Track.count + User.count, @search.count
  end

  test 'find track' do
    track = tracks(:one_untitled)

    assert_includes @search, track
  end

  test 'find user' do
    user = users(:one)

    assert_includes @search, user
  end
end
