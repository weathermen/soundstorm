# frozen_string_literal: true

module TracksHelper
  def segment_url_host
    host = Rails.configuration.action_controller.asset_host ||
           "#{request.scheme}://#{Rails.configuration.host}"

    return host unless host.respond_to? :call

    host.call(request)
  end

  def segment_url(segment)
    ActiveStorage::Current.host = segment_url_host

    segment.blob.service_url(disposition: 'attachment').html_safe
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
    styles = %w(player)
    styles << 'player--disabled' unless track.processed?

    content_tag :section, class: styles, data: data, &block
  end

  def player_link_to(href)
    player_link do
      link_to href do
        yield
      end
    end
  end

  def like_button_for(track, &block)
    if track.user == current_user
      data = { target: 'player.like' }
      content_tag(:span, class: %w(player__stat), data: data, &block)
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

  def oembed_link_tag(format:)
    type = Mime::Type.lookup_by_extension(format)

    tag :link, \
      rel: 'alternate',
      type: "#{type}+oembed",
      href: url_for(host: Rails.configuration.host, format: format)
  end

  private

  def player_link(&block)
    content_tag :span, class: 'player__stat' do
      yield
    end
  end

  def like_button(track)
    method = if current_user&.likes?(track)
      :delete
    else
      :post
    end
    options = {
      method: method,
      remote: true,
      class: %w(player__link button button--small),
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
