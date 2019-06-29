# frozen_string_literal: true

require 'test_helper'
require 'socket'

Capybara.server = :puma, { Silent: true }

Capybara.register_server :puma do |app, port, _host|
  require 'rack/handler/puma'
  Rack::Handler::Puma.run(app, Host: '0.0.0.0', Port: port, Threads: '0:4')
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, \
            using: :chrome,
            screen_size: [1400, 1400],
            options: {
              url: 'http://chrome:4444/wd/hub'
            }

  setup do
    host! "http://#{IPSocket.getaddress(Socket.gethostname)}"
  end

  def sign_in(user, password = 'Password1!')
    visit new_user_session_url

    fill_in 'Username', with: user.name
    fill_in 'Password', with: password

    click_button 'Log in'

    assert_text 'Signed in successfully.'
  end
end
