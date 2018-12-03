# frozen_string_literal: true

require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test 'search for track' do
    track = tracks(:one_untitled)

    VCR.use_cassette :search_track do
      get search_url, params: { q: track.name }
    end

    assert_response :success
  end

  test 'search for user' do
    user = users(:one)

    VCR.use_cassette :search_user do
      get search_url, params: { q: user.name }
    end

    assert_response :success
  end
end
