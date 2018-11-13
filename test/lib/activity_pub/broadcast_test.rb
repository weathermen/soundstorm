require 'test_helper'

module ActivityPub
  class BroadcastTest < ActiveSupport::TestCase
    setup do
      @destination = 'https://destination.host'
      @private_key_pem = Rails.root.join(
        'test', 'fixtures', 'files', 'actor.pem'
      ).read
      @actor = Actor.new(
        host: 'test.host',
        name: 'actor',
        key: @private_key_pem,
        secret: 'passphrase'
      )
      @message = Message.new(
        id: '12345',
        type: 'Note',
        actor: @actor,
        content: '<p>Hello World</p>'
      )
      @broadcast = Broadcast.new(message: @message, destination: @destination)
    end

    test 'deliver' do
      skip 'until we can use vcr'
      assert @broadcast.deliver
      assert_equal 200, @broadcast.response.code
    end

    test 'headers' do
      assert_equal @destination, @broadcast.headers[:Host]
      assert_equal @message.date, @broadcast.headers[:Date]
      assert_equal @broadcast.signature.header, @broadcast.headers[:Signature]
    end

    test 'signature' do
      assert_kind_of Signature, @broadcast.signature
    end
  end
end
