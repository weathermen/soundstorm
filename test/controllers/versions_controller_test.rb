require 'test_helper'

class VersionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)

    sign_in @user
  end

  test 'post activity to inbox' do
    post inbox_path, params: {
      '@context': ActivityPub::ACTIVITYSTREAMS_NAMESPACE,
      id: 'https://test.host/one/untitled/comments/12345',
      type: 'Create',
      actor: @user.as_actor,
      object: {
        type: 'Note',
        id: 'https://test.host/one/untitled/comments/12345',
        content: 'hello world'
      }
    }

    assert_response :accepted
    assert_enqueued_jobs 1, only: UpdateActivityJob
  end
end
