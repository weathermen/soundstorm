require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test 'internal server error' do
    skip
    get '/500'

    assert_response :internal_server_error
  end

  test 'not found' do
    skip
    get '/foo'

    assert_response :not_found
  end

  test 'too many requests' do
    skip
    get '/429'

    assert_response 429
  end
end
