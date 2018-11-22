module TracksHelper
  def track_player_button(audio)
    bindings = { target: 'player.button', action: 'click->player#toggle' }

    return unless audio.attached?
    button_to 'Play', audio.url, data: bindings
  end
end
