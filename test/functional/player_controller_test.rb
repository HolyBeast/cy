require 'test_helper'

class PlayerControllerTest < ActionController::TestCase
  test "should get register" do
    get :register
    assert_response :success
  end

end
