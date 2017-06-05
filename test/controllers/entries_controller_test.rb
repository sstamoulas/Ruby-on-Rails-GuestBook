require 'test_helper'

class EntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_in" do
    get entries_sign_in_url
    assert_response :success
  end

end
