# frozen_string_literal: true

# Create initial admin user
User.create!(
  name: Soundstorm::ADMIN_USERNAME,
  email: Soundstorm::ADMIN_EMAIL,
  password: Soundstorm::ADMIN_PASSWORD,
  display_name: 'Soundstorm Administrator',
  confirmed_at: Time.current
)
