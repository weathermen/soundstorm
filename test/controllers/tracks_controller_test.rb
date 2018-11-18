require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = tracks(:one_untitled)
    sign_in users(:one)
  end

  test 'view track' do
    get user_track_url(@track.user, @track)

    assert_response :success
  end

  test 'create new track' do
    attributes = {
      name: 'New Track',
      audio: nil
    }

    get new_track_url

    assert_response :success

    post tracks_url,
      params: { track: attributes },
      env: { 'devise.mapping' => Devise.mappings[:user] }

    assert_response :created

    track = Track.last

    assert_equal attributes[:name], track.name
    refute_nil track.duration
  end

  test 'update existing track' do
    get edit_track_url(@track)

    assert_response :success

    patch track_url(@track), params: { track: { name: 'New Name' } }

    assert_response :success
    assert @track.reload
    assert_equal 'New Name', @track.name
    assert_equal 'new-name', @track.slug
  end

  test 'delete existing track' do
    delete track_url(@track)

    assert_redirected_to @track.user
    assert_raises(ActiveRecord::RecordNotFound) { @track.reload }
  end
end
