require "test_helper"

class PublicRunsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_runs_index_url
    assert_response :success
  end

  test "should get show" do
    get public_runs_show_url
    assert_response :success
  end
end
