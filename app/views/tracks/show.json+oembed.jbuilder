# frozen_string_literal: true

json.type 'video'
json.version 1.0
json.title @track.title
json.author_name @track.artist
json.author_url user_url(@user)
json.provider_name 'Soundstorm'
json.provider_url root_url
json.cache_age 90.minutes
json.thumbnail_url url_for(@track.waveform)
json.thumbnail_width @track.waveform.metadata[:width]
json.thumbnail_height @track.waveform.metadata[:height]
json.width @track.waveform.metadata[:width]
json.height @track.waveform.metadata[:height]
json.html render('player.html', track: @track)
