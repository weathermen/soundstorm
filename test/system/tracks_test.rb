require "application_system_test_case"

class TracksTest < ApplicationSystemTestCase
  test 'viewing a track' do
    visit user_track_url(@user, @track)

    assert_text 'New Track Name'
  end

  test 'uploading a track' do
    visit new_track_url

    fill_in 'Name', with: 'New Track Name'
  end

  test 'editing an uploaded track' do
    visit user_track_url(@user, @track)

    refute_text 'Edit'

    sign_in @user
    visit user_track_url(@user, @track)

    click_button 'Edit'

    fill_in 'Name', with: 'New Track Name'
    attach_file 'Audio', @audio

    click_button 'Save'

    assert_text 'New Track Name'
  end
end
