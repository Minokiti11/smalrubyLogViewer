require "test_helper"

class LogsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get logs_show_url
    assert_response :success
  end
end
