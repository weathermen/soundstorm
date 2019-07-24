# frozen_string_literal: true

require 'test_helper'

module ActivityPub
  class BroadcastTest < ActiveSupport::TestCase
    setup do
      @destination = 'soundstorm.test'
      @private_key_pem = Rails.root.join(
        'test', 'fixtures', 'files', 'actor.pem'
      ).read
      @actor = Actor.new(
        host: 'test.host',
        name: 'actor',
        summary: 'Actor',
        key: @private_key_pem,
        secret: 'passphrase'
      )
      @message = Message.new(
        id: '12345',
        type: 'Update',
        actor: @actor,
        payload: {
          type: 'Note',
          content: 'Hello World'
        }
      )
      @broadcast = Broadcast.new(message: @message, destination: @destination)
    end

    test 'deliver' do
      response = Minitest::Mock.new
      response.expect(:code, 201)

      @broadcast.send(:request).stub(:post, response) do
        assert @broadcast.deliver
        assert_equal 201, @broadcast.response.code
      end
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
