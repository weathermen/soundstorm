require 'test_helper'

module ActivityPub
  class MessageTest < ActiveSupport::TestCase
    setup do
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
          id: '12345',
          type: 'Note',
          published: Time.now.utc.httpdate,
          content: '<p>Hello World.</p>'
        }
      )
    end

    test 'attributes' do
      assert_equal @message.published.utc.httpdate, @message.attributes[:published]
      assert_equal "#{ACTIVITYSTREAMS_NAMESPACE}#Public", @message.attributes[:to]
      assert_nil @message.attributes[:inReplyTo]
    end

    test 'json representation' do
      assert_equal ACTIVITYSTREAMS_NAMESPACE, @message.as_json[:@context]
    end
  end
end
