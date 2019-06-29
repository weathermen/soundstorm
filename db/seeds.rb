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
    confirmed_at: Time.current,
  )
  track = fan.tracks.create!(
    name: 'Listerine Dreams',
    audio: Rails.root.join('test', 'fixtures', 'files', 'one.mp3').open
  )

  fan.follow!(admin)
  admin.like!(track)
end
