require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "search for items" do
    get search_url, params: { q: '*' }

    assert_response :success
  end
end
