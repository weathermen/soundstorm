require 'test_helper'

class TrackListenTest < ActiveSupport::TestCase
  setup do
    @track = tracks(:one_untitled)
  end

  test 'unique by ip' do
    ip = '192.168.1.1'
    listen = @track.listens.create(ip_address: ip)

    refute listen.valid?, "#{listen} is valid when it shouldn't be"

    listen.ip_address = '192.168.1.4'

    assert listen.valid?, listen.errors.full_messages.to_sentence
  end

  test 'unique by user' do
    user = users(:one)
    listen = @track.listens.create(
      user: user,
      ip_address: '192.168.1.3'
    )

    refute listen.valid?, "#{listen} is valid when it shouldn't be"

    listen.user = users(:two)

    assert listen.valid?, listen.errors.full_messages.to_sentence

    listen.user = nil

    assert listen.valid?, listen.errors.full_messages.to_sentence
  end
end
