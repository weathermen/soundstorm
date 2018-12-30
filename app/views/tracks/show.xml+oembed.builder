# frozen_string_literal: true

xml.oembed do |oembed|
  oembed.type 'video'
  oembed.version 1.0
  oembed.title @track.title
  oembed.author_name @track.artist
  oembed.author_url user_url(@user)
  oembed.provider_name 'Soundstorm'
  oembed.provider_url root_url
  oembed.cache_age 90.minutes
  oembed.thumbnail_url url_for(@track.waveform)
  oembed.thumbnail_width @track.waveform.metadata[:width]
  oembed.thumbnail_height @track.waveform.metadata[:height]
  oembed.width @track.waveform.metadata[:width]
  oembed.height @track.waveform.metadata[:height]
  oembed.html render('player.html', track: @track)
end
