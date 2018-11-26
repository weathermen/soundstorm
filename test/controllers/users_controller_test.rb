# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @resource = "acct:#{@user.handle}"
  end

  test 'view user profile' do
    get user_url(@user)

    assert_response :success
  end

  test 'view actor response' do
    get user_url(@user, format: 'json')

    assert_response :success
    refute_empty response.body

    json = JSON.parse(response.body.to_s).deep_symbolize_keys
    profile = user_url(@user, host: @user.host, protocol: 'https')
    inbox = inbox_user_url(@user, host: @user.host, protocol: 'https', format: :json)
    key_id = user_url(@user, anchor: 'main-key', host: @user.host, protocol: 'https')

    assert_includes json[:@context], ActivityPub::ACTIVITYSTREAMS_NAMESPACE
    assert_includes json[:@context], ActivityPub::W3ID_NAMESPACE
    assert_equal profile, json[:id]
    assert_equal 'Person', json[:type]
    assert_equal @user.name, json[:preferredUsername]
    assert_equal inbox, json[:inbox]
    assert_equal key_id, json[:publicKey][:id]
    assert_equal profile, json[:publicKey][:owner]
    assert_equal @user.actor.public_key.to_pem, json[:publicKey][:publicKeyPem]
  end

  test 'view webfinger response' do
    get webfinger_url, params: { resource: @resource }

    json = JSON.parse(response.body.to_s).deep_symbolize_keys
    link = json[:links].first

    assert_response :success
    assert_equal @resource, json[:subject]
    assert_equal ActivityPub::Actor::WEBFINGER_REL, link[:rel]
    assert_equal ActivityPub::Actor::WEBFINGER_CONTENT_TYPE, link[:type]
    assert_equal @user.actor.id, link[:href]
  end
end
