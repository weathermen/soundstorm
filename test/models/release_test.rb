# frozen_string_literal: true

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  test 'order tracks by number' do
    track1 = tracks(:one_released_one)
    track2 = tracks(:one_titled)
    track3 = tracks(:one_released_two)
    release = releases(:one)

    assert_equal [track1, track2, track3], release.tracks_by_number
  end
end
