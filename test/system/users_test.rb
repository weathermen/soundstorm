require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test 'view user profile' do
    visit user_url(@user)

    assert_text @user.display_name
    assert_text "#{I18n.t(:location, scope: %i[users show])} #{@user.location}"
    assert_text "#{I18n.t(:biography, scope: %i[users show])} #{@user.biography}"
    assert_text "#{@user.followers_count} #{I18n.t(:followers, scope: %i[users show])}"
    assert_text "#{@user.following_count} #{I18n.t(:following, scope: %i[users show])}"
    assert_text "#{@user.tracks_count} #{I18n.t(:tracks, scope: %i[users show])}"
    assert_text I18n.t(:follow, scope: %i[users show])
    assert_text @user.tracks.first.name
    assert_selector '.profile__avatar'

    sign_in @user.followers.first
    visit user_url(@user)

    assert_text I18n.t(:unfollow, scope: %i[users show])

    sign_in @user
    visit user_url(@user)

    assert_text I18n.t(:upload, scope: %i[users show])

    @user.tracks.destroy_all
    visit user_url(@user)

    assert_text I18n.t(:empty, scope: %i[users show])
  end

  test 'sign up for an account' do
    visit new_user_registration_url

    fill_in 'Name', with: 'username'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'Password1!'
    fill_in 'Password Confirmation', with: 'Password1!'

    click 'Sign Up'

    assert_text I18n.t(:signed_up_but_unconfirmed, scope: %i[devise registrations])

    visit confirmation_url(@user, confirmation_token: @user.confirmation_token)

    assert_text I18n.t(:confirmed, scope: %i[devise confirmations])
  end
end
