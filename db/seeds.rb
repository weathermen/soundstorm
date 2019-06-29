# frozen_string_literal: true

# Create initial admin user
admin = User.create!(
  name: Soundstorm::ADMIN_USERNAME,
  email: Soundstorm::ADMIN_EMAIL,
  password: Soundstorm::ADMIN_PASSWORD,
  display_name: 'Soundstorm Administrator',
  confirmed_at: Time.current,
  admin: true
)

if Rails.env.development?
  fan = User.create!(
    name: 'fan',
    email: 'fan@example.com',
    password: Soundstorm::ADMIN_PASSWORD,
    display_name: 'Fan',
    confirmed_at: Time.current
  )
  artist = User.create!(
    name: 'artist',
    email: 'artist@example.com',
    password: Soundstorm::ADMIN_PASSWORD,
    display_name: 'Another Artist',
    confirmed_at: Time.current
  )
  PaperTrail.request.whodunnit = artist.id
  track = artist.tracks.build(name: 'Listerine Dreams')
  audio = Rails.root.join('test', 'fixtures', 'files', 'one.mp3')

  track.audio.attach(io: audio.open, filename: audio.basename)
  track.save!
  ProcessTrackJob.perform_now(track)
  PaperTrail.request.whodunnit = admin.id
  admin.follow!(artist)
  admin.like!(track)
  PaperTrail.request.whodunnit = fan.id
  fan.follow!(admin)
end
