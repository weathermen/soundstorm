# frozen_string_literal: true

# Create initial admin user
User.create!(
  name: ENV.fetch('SOUNDSTORM_ADMIN_USERNAME', 'admin'),
  email: ENV.fetch('SOUNDSTORM_ADMIN_EMAIL', 'admin@example.com'),
  password: ENV.fetch('SOUNDSTORM_ADMIN_PASSWORD', 'Password1!'),
  display_name: 'Soundstorm Administrator'
)
