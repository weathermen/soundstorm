# frozen_string_literal: true

require 'test_helper'

module ActivityPub
  class ActorTest < ActiveSupport::TestCase
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
    end

    test 'public and private key' do
      assert_equal @actor.private_key.to_pem, @private_key_pem
      assert_equal @actor.public_key.to_pem, @actor.private_key.public_key.to_pem
    end

    test 'id' do
      assert_equal 'https://test.host/actor', @actor.id
    end

    test 'type' do
      assert_equal Actor::DEFAULT_TYPE, @actor.type
    end

    test 'json representation' do
      assert_includes @actor.as_json[:@context], ACTIVITYSTREAMS_NAMESPACE
      assert_includes @actor.as_json[:@context], W3ID_NAMESPACE
      assert_equal @actor.type, @actor.as_json[:type]
      assert_equal @actor.id, @actor.as_json[:id]
      assert_equal @actor.name, @actor.as_json[:preferredUsername]
      assert_equal @actor.public_key.to_pem, @actor.as_json[:publicKey][:publicKeyPem]
    end

    test 'find' do
      VCR.use_cassette :find_actor do
        actor = Actor.find('https://www.soundstorm.social/tubbo.json')

        refute_nil actor
        assert_equal 'tubbo', actor.name
        assert_kind_of OpenSSL::PKey::RSA, actor.public_key
      end
    end

    test 'from' do
      key = OpenSSL::PKey::RSA.new(@private_key_pem, 'passphrase')
      json = {
        'type' => 'Person',
        'name' => 'someone',
        'summary' => 'Somebody Out There',
        'publicKey' => {
          'publicKeyPem' => key.public_key.to_pem
        }
      }
      actor = Actor.from(json, host: 'soundstorm.social')

      assert_kind_of Actor, actor
      assert_equal 'someone', actor.name
      assert_equal 'Somebody Out There', actor.summary
      assert_kind_of OpenSSL::PKey::RSA, actor.public_key
    end
  end
end
