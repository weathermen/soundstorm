# frozen_string_literal: true

require 'application_system_test_case'

class ReleasesTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test 'adding a new release' do
    skip
    path = Rails.root.join('test', 'fixtures', 'files', 'one.mp3').to_s

    sign_in @user
    visit new_release_url

    fill_in 'release_name', with: 'Release Name'
    fill_in 'release_description', with: 'Release Description'
    fill_in 'release_released_tracks_attributes_0_track_attributes_name', \
      with: 'Track Name'
    attach_file 'release_released_tracks_attributes_0_track_attributes_audio', path

    click_button 'Create'

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
