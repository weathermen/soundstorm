require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'view user profile' do
    user = users(:one)

    get user_url(user)

    assert_response :success
  end

  test 'view actor response' do
    user = users(:one)

    get user_url(user, format: :json)

    assert_response :success

    json = JSON.parse(response.body.to_s).deep_symbolize_keys

    assert_includes json[:@context], Rails.configuration.activity_streams_context
    assert_equal json[:id], url_for(user, format: :json)
    assert_equal json[:type], 'Person'
    assert_equal json[:preferredUsername], user.name
    assert_equal json[:inbox], inbox_url
    assert_equal json[:publicKey][:id], "#{url_for(user)}#main-key"
    assert_equal json[:publicKey][:owner], url_for(user, format: :json)
    assert_equal json[:publicKey][:publicKeyPem], user.public_key.to_pem
  end
end
