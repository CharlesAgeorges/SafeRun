require "test_helper"

class IncidentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get incidents_show_url
    assert_response :success
  end

  test "should get index" do
    get incidents_index_url
    assert_response :success
  end
end
