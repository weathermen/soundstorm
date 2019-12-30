# frozen_string_literal: true

# Create initial admin user
creds = Rails.credentials.admin_user || {}
raise "Error: You must set up admin user credentials" \
  if Rails.env.production? && creds.empty?
admin = User.create!(
  creds.reverse_merge(
    name: 'admin',
    email: 'admin@example.com',
    password: 'Password1!',
    password_confirmation: creds[:password] || 'Password1!',
    confirmed_at: Time.current,
    display_name: 'Soundstorm Administrator',
    admin: true
  )
)

# Create development seed data
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
