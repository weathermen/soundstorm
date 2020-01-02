require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  test 'view track comments' do
    comment = comments(:one_untitled_praise)

    visit user_track_url(comment.track.user, comment.track)

    assert_text comment.content
  end

  test 'add comment to track' do
    author = users(:one)
    commenter = users(:two)
    track = user.tracks.first

    visit user_track_url(author, track)

    refute_selector '.comment-form'

    sign_in commenter
    visit user_track_url(author, track)

    fill_in 'comment_content', with: 'A new comment'
    click 'Save'

    assert_text 'A new comment'
  end
end
