require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @liker = users(:one)
    @track = tracks(:two_hello_world)

    sign_in @liker
  end

  test 'like track' do
    post user_track_like_url(@track.user, @track)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @track
    assert_includes @liker.liked_tracks, @track
  end

  test 'unlike track' do
    delete user_track_like_url(@track.user, @track)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @track
    refute_includes @liker.liked_tracks, @track
  end
end
