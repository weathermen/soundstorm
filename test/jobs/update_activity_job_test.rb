# frozen_string_literal: true

require 'test_helper'

class UpdateActivityJobTest < ActiveJob::TestCase
  test 'create a new version when activity is received' do
    host = 'other.host'
    private_key_path = Rails.root.join('test', 'fixtures', 'files', 'actor.pem')
    private_key = OpenSSL::PKey::RSA.new(private_key_path.read)
    actor = ActivityPub::Actor.new(
      name: 'actor',
      host: host,
      key: private_key,
      secret: 'foo',
      summary: 'Foo Bar'
    )

    ActivityPub::Actor.stub :find, actor do
      user = User.find_or_create_by_actor_id(actor.id)
      track = tracks(:one_untitled)
      activity = ActivityPub::Activity.new(
        id: 'https://test.host/one/untitled/comments/123',
        type: 'Note',
        actor: actor.id,
        object: {
          track_id: track.id,
          content: 'nice one bruva'
        }
      )

      assert_difference -> { Comment.count } do
        UpdateActivityJob.perform_now(user, activity)
      end
      assert_equal 1, PaperTrail::Version.count
    end
  end
end
