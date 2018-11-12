require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'handle' do
    user = User.new(name: 'test')
    domain = Rails.application.credentials.host

    assert_equal "test@#{domain}", user.handle
  end

  test 'keypair' do
  end
end
