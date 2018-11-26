# frozen_string_literal: true

require 'test_helper'

class TrackListenTest < ActiveSupport::TestCase
  setup do
    @track = tracks(:one_untitled)
  end

  test 'unique by ip' do
    listen = @track.listens.create(ip_address: '71.185.223.138')

    assert listen.valid?, listen.errors.full_messages.to_sentence

    listen = @track.listens.create(ip_address: '71.185.223.138')

    refute listen.valid?
  end

  test 'unique by user' do
    user = users(:one)
    listen = @track.listens.create(
      user: user,
      ip_address: '71.185.223.138'
    )

    assert listen.valid?, listen.errors.full_messages.to_sentence

    listen = @track.listens.create(
      user: user,
      ip_address: '71.185.223.138'
    )

    refute listen.valid?
  end

  test 'must have valid ip' do
    listen = @track.listens.create

    refute listen.valid?

    listen = @track.listens.create(user: users(:one))

    refute listen.valid?
  end
end
