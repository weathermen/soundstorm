require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "search for track" do
    track = tracks(:one_untitled)

    get search_url, params: { q: track.name }

    assert_response :success
  end

  test "search for user" do
    user = users(:one)

    get search_url, params: { q: user.name }

    assert_response :success
  end
end
