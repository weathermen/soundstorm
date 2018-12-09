# frozen_string_literal: true

module CommentsHelper
  def comment_path(comment)
    user_track_path(comment.track.user, comment.track, anchor: "comment-#{comment.id}")
  end
end
