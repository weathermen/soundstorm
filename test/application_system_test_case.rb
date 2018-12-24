# frozen_string_literal: true

require 'test_helper'

Capybara.server = :puma, { Silent: true }

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def sign_in(user, password = 'Password1!')
    visit new_user_session_url

    fill_in 'Username', with: user.name
    fill_in 'Password', with: password

    click_button 'Log in'

    assert_text 'Signed in successfully.'
  end
end
