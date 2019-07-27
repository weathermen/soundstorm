# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'compute handle from configured host' do
    name = 'test'
    domain = Rails.configuration.host
    user = User.new(
      name: name,
      email: "#{name}@example.com",
      password: 'Password1!'
    )

    assert user.valid?, user.errors.full_messages.to_sentence
    assert_equal "#{name}@#{domain}", user.handle
  end

  test 'generate private key for new user' do
    user = User.create(
      name: 'new-user',
      host: Rails.configuration.host,
      display_name: 'New User',
      password: 'HelloD0lly1!',
      email: 'new-user@example.com'
    )

    assert user.valid?, user.errors.full_messages.to_sentence
    assert user.key_pem.present?
    assert user.actor.public_key.present?
  end

  test 'regenerate private key when password changes' do
    user = users(:one)

    assert_changes -> { user.key_pem } do
      assert user.update!(password: 'TotallyN3wPassword$')
    end
  end

  test 'find by webfinger resource' do
    user = users(:one)

    assert_equal user, User.find_by_resource("acct:#{user.handle}")
  end
end
