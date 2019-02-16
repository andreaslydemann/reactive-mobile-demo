require 'test_helper'

class GameSessionControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get game_session_start_url
    assert_response :success
  end

end
