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
json.thumbnail_width 1000
json.thumbnail_height 200
json.width Rails.configuration.oembed_width
json.height Rails.configuration.oembed_height
json.html render('embedded.html', track: @track)
