require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @track = tracks(:two_hello_world)

    sign_in @user
  end

  test 'like track' do
    post user_track_like_url(@track.user, @track)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @track
    assert_includes @user.likes, @track
  end

  test 'unlike track' do
    @user.like!(@track)
    delete user_track_like_url(@track.user, @track)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @track
    refute_includes @user.likes, @track
  end
end
