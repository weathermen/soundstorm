# frozen_string_literal: true

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  setup do
    User.__elasticsearch__.create_index! force: true
    [User, Track, Comment].each(&:import)
    User.__elasticsearch__.refresh_index!
  end

  test 'count' do
    search = Search.new(query: '*')
    all_models = [User, Track, Comment].map { |m| m.all.to_a }.flatten

    all_models.each do |model|
      assert_includes search, model
    end
  end

  test 'find track' do
    track = tracks(:one_untitled)
    search = Search.new(query: track.name)

    assert_includes search, track
  end

  test 'find user' do
    user = users(:one)
    search = Search.new(query: user.display_name)

    assert_includes search, user
  end
end
