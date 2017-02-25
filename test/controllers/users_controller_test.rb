require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:stuart_bradley)
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end
end
