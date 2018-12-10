# frozen_string_literal: true

require 'test_helper'

class TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = tracks(:one_untitled)
    @user = users(:one)

    sign_in @user
  end

  test 'view track' do
    get user_track_url(@track.user, @track)

    assert_response :success
  end

  test 'create new track' do
    audio = fixture_file_upload('files/one.mp3', 'audio/mpeg')
    attributes = {
      name: 'New Track',
      audio: audio
    }

    get new_track_url

    assert_response :success

    post tracks_url, params: { track: attributes }
    track = Track.last

    assert_redirected_to [@user, track], flash[:alert]
    assert_equal attributes[:name], track.name
  end

  test 'update existing track' do
    audio = fixture_file_upload('files/one.mp3', 'audio/mpeg')
    @track.audio.attach(io: audio, filename: 'one.mp3')
    get edit_track_url(@track)

    assert_response :success

    patch track_url(@track), params: { track: { name: 'New Name' } }

    assert_redirected_to [@user, @track], flash[:alert]
    assert @track.reload
    assert_equal 'New Name', @track.name
  end

  test 'delete existing track' do
    delete track_url(@track)

    assert_redirected_to @track.user
    assert_raises(ActiveRecord::RecordNotFound) { @track.reload }
  end
end
