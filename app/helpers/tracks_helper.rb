module TracksHelper
  def track_player_button(audio)
    bindings = { target: 'player.button', action: 'click->player#toggle' }

    return unless audio.attached?
    button_to t('.play'), audio.url, data: bindings
  end

  def player_for(track, &block)
    data = {
      controller: 'player',
      track: url_for([track.user, track])
    }

    content_tag :section, class: 'player', data: data, &block
  end
end
