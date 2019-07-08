# frozen_string_literal: true

require 'test_helper'

module ActivityPub
  class Actor
    class FingerTest < ActiveSupport::TestCase
      setup do
        @finger = Finger.new(
          name: 'lester',
          host: 'test.host',
          href: @href
        )
      end

      test 'id' do
        assert_equal 'acct:lester@test.host', @finger.id
      end

      test 'json' do
        link = @finger.as_json[:links].first

        assert_equal @finger.id, @finger.as_json[:subject]
        assert_equal Finger::RELATIONSHIP, link[:rel]
        assert_equal Finger::CONTENT_TYPE, link[:type]
        assert_equal 'https://test.host/lester', link[:href]
      end

      test 'find' do
        skip 'until we can figure out local VCR requests'
        VCR.use_cassette :webfinger do
          finger = Finger.find('acct:admin@soundstorm.test')

          refute_nil(finger)
          assert_equal('acct:admin@soundstorm.test', finger.id)
          assert_equal('https://soundstorm.test/admin', finger.links.first[:href])
        end
      end
    end
  end
end
