module TracksHelper
  def track_player_button(url)
    bindings = { target: 'player.button', action: 'click->player#toggle' }

    button_to 'Play', track.audio.url, data: bindings
  end
end
