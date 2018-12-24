# frozen_string_literal: true

require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  test 'order tracks by number' do
    track1 = tracks(:one_untitled)
    track2 = tracks(:one_titled)
    release = releases(:one)

    assert_equal [track1, track2], release.tracks_by_number
  end
end
