# frozen_string_literal: true

module TracksHelper
  def segment_url(segment)
    ActiveStorage::Current.host = "#{request.scheme}://#{Rails.configuration.host}"
    blob = segment.blob
    ActiveStorage::Blob.service.url(
      segment.blob.key,
      disposition: 'attachment',
      filename: blob.filename,
      content_type: blob.content_type,
      expires_in: 1.hour
    ).html_safe
  end

  def track_player_button(track)
    return unless track.audio.attached?

    options = {
      data: {
        target: 'player.button',
        action: 'click->player#toggle'
      },
      title: t('.play'),
      class: %w(
        player__icon
        player__icon--paused
      )
    }
    href = user_track_url(track.user, track, format: :m3u8)

    link_to '&nbsp'.html_safe, href, options
  end

  def player_for(track, &block)
    data = {
      controller: 'player',
      'player-track': user_track_path(track.user, track),
      'player-liked': current_user&.likes?(track),
      'player-duration': track.duration,
      'player-seek-position': 0
    }

    content_tag :section, class: 'player', data: data, &block
  end

  def like_button_for(track, &block)
    if track.user == current_user
      player_link(&block)
    else
      like_button(track, &block)
    end
  end

  def track_comments_url(track)
    user_track_url(track.user, track, anchor: 'comments')
  end

  def track_download_url(track)
    user_track_url(track.user, track, format: :mp3)
  end

  def track_video_tag_options
    {
      target: 'player.video',
      action: 'playing->player#start ended->player#stop'
    }
  end

  private

  def player_link(&block)
    content_tag :span, class: 'player__link' do
      yield
    end
  end

  def like_button(track)
    options = {
      method: :post,
      class: 'player__link',
      data: {
        action: 'ajax:success->player#like',
        target: 'like'
      }
    }

    button_to [track.user, track, :like], options do
      yield
    end
  end
end
