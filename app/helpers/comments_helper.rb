# frozen_string_literal: true

module CommentsHelper
  def comment_path(comment)
    user_track_path(comment.track.user, comment.track, anchor: "comment-#{comment.id}")
  end

  def comment_date(comment)
    t('.commented', date: distance_of_time_in_words_to_now(comment.created_at))
  end
end
