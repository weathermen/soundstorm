# frozen_string_literal: true

module TracksHelper
  def track_player_button(audio)
    bindings = { target: 'player.button', action: 'click->player#toggle' }

    return unless audio.attached?

    button_to t('.play'), url_for(audio), data: bindings
  end

  def player_for(track, &block)
    data = {
      controller: 'player',
      track: url_for([track.user, track])
    }

    content_tag :section, class: 'player', data: data, &block
  end

  def like_button(track)
    data = {
      action: 'ajax:success->player#like',
      target: 'like'
    }
    button_to [track.user, track, :like], method: :post, data: data, class: 'player__link' do
      yield
    end
  end
end
