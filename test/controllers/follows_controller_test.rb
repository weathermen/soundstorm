require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @follower = users(:one)
    @following = users(:two)

    sign_in @follower
  end

  test 'follow user' do
    post user_follow_url(@following)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @following
  end

  test 'unfollow user' do
    delete user_follow_url(@following)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @following
  end
end
