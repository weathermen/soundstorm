# frozen_string_literal: true

require 'application_system_test_case'

class ReleasesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test 'adding a new release' do
    sign_in @user
    visit new_release_url

    fill_in 'release[name]', with: 'Release Name'
    fill_in 'release[description]', with: 'Release Description'

    click_button 'Save'

    assert_text 'Error creating Release: Tracks must be uploaded'

    fill_in 'release[released_tracks_attributes][0][track_attributes][name]', \
      with: 'Track Name'
    fill_in 'release[released_tracks_attributes][0][number]', \
      with: 1
    attach_file \
      'release[released_tracks_attributes][0][track_attributes][audio]',
      fixture_file_upload('files/one.mp3', 'audio/mpeg')

    click_button 'Save'

    assert_text 'New Release "Release Name" has been created'
  end

  test 'viewing and editing an existing release' do
    release = @user.releases.first
    description = 'A new description of the release'

    sign_in @user
    visit user_release_url(@user, release)

    assert_text release.name
    assert_text release.description
    assert_text 'Delete'

    click_link 'Edit'

    fill_in 'release[description]', with: description

    click_button 'Save'

    assert_text %(Saved changes on Release "#{release.name}")
    assert_text description
  end
end
