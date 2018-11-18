require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = tracks(:one_untitled)
    @user = @track.user
    sign_in users(:two), 'Password2!'
  end

  test 'post comment on track' do
    post user_track_comments_url(@user, @track), params: { comment: { content: 'foo' } }

    assert_redirected_to @track
    assert_nil flash[:alert]
    refute_nil flash[:notice]
    assert_equal 'foo', @track.comments.last.content
  end

  test 'edit comment on track' do
    comment = @track.comments.first
    get edit_user_track_comment_url(@user, @track, comment)

    assert_response :success

    patch user_track_comment_url(@user, @track, comment), params: { comment: { content: 'edited' } }

    assert_redirected_to @track
    assert_equal 'edited', comment.reload.content
  end

  test 'remove comment from track' do
    comment = @track.comments.first

    delete user_track_comment_url(@user, @track, comment)

    assert_redirected_to @track
    assert_empty @track.comments
  end
end
