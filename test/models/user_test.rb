require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'compute handle from configured host' do
    name = 'test'
    domain = Rails.configuration.host
    user = User.new(name: name)

    assert_equal "#{name}@#{domain}", user.handle
  end

  test 'generate private key for new user' do
    user = User.create(
      name: 'new-user',
      display_name: 'New User',
      password: 'HelloD0lly1!',
      email: 'new-user@example.com'
    )

    assert user.valid?, user.errors.full_messages.to_sentence
    assert user.key_pem.present?
    assert user.private_key.present?
    assert user.public_key.present?
    assert_equal user.public_key.to_pem, user.private_key.public_key.to_pem
  end

  test 'regenerate private key when password changes' do
    user = users(:one)

    assert_changes -> { user.public_key.to_pem } do
      assert user.update!(password: 'TotallyN3wPassword$')
    end
    assert_changes -> { user.private_key.to_pem } do
      assert user.update!(password: 'AnotherTotallyN3wPassword$')
    end
  end
end
