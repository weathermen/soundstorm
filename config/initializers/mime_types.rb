# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:

# MP3 File Download
Mime::Type.register 'audio/mpeg', :mp3

# M3U8 Stream Playlist
Mime::Type.register 'application/vnd.apple.mpegurl', :m3u8
