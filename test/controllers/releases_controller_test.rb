# frozen_string_literal: true

require 'test_helper'

class ReleasesControllerTest < ActionDispatch::IntegrationTest
  test 'view a release' do
    release = releases(:one)

    get user_release_path(release.user, release)

    assert_response :ok
  end

  test 'create a new release' do
    user = users(:one)
    audio = fixture_file_upload('files/one.mp3', 'audio/mpeg')

    sign_in user

    assert_difference -> { Release.count } do
      post releases_url, params: {
        release: {
          name: 'New Release',
          released_tracks_attributes: [
            {
              number: 1,
              track_attributes: {
                name: 'Track 1',
                user_id: user.id,
                audio: audio
              }
            },
            {
              number: 2,
              track_attributes: {
                name: 'Track 2',
                user_id: user.id,
                audio: audio
              }
            }
          ]
        }
      }
      release = Release.last

      assert_nil flash[:alert]
      assert_redirected_to [user, release]
      assert_equal 2, release.tracks.count
    end
  end

  test 'update an existing release' do
    release = releases(:one)
    rt1 = released_tracks(:one)
    rt2 = released_tracks(:two)
    rt3 = released_tracks(:three)

    sign_in release.user

    patch release_url(release), params: {
      release: {
        name: 'Changed Release',
        released_tracks_attributes: [
          {
            id: rt1.id,
            number: 2,
            track_attributes: {
              user_id: release.user_id,
              id: rt1.track_id,
              name: rt1.track.name
            }
          },
          {
            id: rt2.id,
            number: 1,
            track_attributes: {
              id: rt2.track_id,
              user_id: release.user_id,
              name: 'Changed Track Name'
            }
          },
          {
            id: rt3.id,
            number: 3,
            _destroy: 1
          }
        ]
      }
    }

    assert_nil flash[:alert]
    assert_redirected_to [release.user, release]
    assert_equal 'Changed Track Name', rt2.track.name
    assert_equal 2, release.tracks.count
    assert_equal [rt2.track.id, rt1.track.id], release.tracks_by_number.map(&:id)
  end

  test 'delete an existing release' do
    release = releases(:one)

    sign_in release.user
    delete release_url(release)

    assert_redirected_to user_url(release.user)
    assert_raises(ActiveRecord::RecordNotFound) { release.reload }
  end
end
