# frozen_string_literal: true

require 'test_helper'

module ActivityPub
  class Actor
    class FingerTest < ActiveSupport::TestCase
      setup do
        @finger = Finger.new(
          name: 'lester',
          host: 'test.host',
          href: 'https://test.host/lester'
        )
      end

      test 'id' do
        assert_equal 'acct:lester@test.host', @finger.id
      end

      test 'json' do
        link = @finger.as_json[:links].first

        assert_equal @finger.id, @finger.as_json[:id]
        assert_equal Finger::RELATIONSHIP, link[:rel]
        assert_equal Finger::CONTENT_TYPE, link[:type]
        assert_equal @finger.href, link[:href]
      end
    end
  end
end
