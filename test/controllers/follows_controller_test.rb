require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @follower = users(:one)
    @followed = users(:two)

    sign_in @follower
  end

  test 'follow user' do
    skip
    post user_follow_url(@followed)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @followed
  end

  test 'unfollow user' do
    skip
    @follower.follows.create!(followed: @followed)
    delete user_follow_url(@followed)

    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_redirected_to @followed
  end
end
