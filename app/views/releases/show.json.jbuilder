json.release do
  json.id @release.id
  json.name @release.name
  json.slug @release.slug
  json.artist @release.artist
  json.array! :tracks do
    @release.tracks_by_number.each_with_index do |track, index|
      number = index + 1

      json.name track.name
      json.number number
      json.description track.description
      json.likes track.likes_count
      json.url user_track_url(track.user, track, format: :m3u8)
    end
  end
end
