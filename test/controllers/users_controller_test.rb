require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "show non_manager userpage" do
    user = User.where(:login => 'stuart.bradley').first
    sign_in user
    get :show, params: {id: user.id}
    assert_response :success, "Route was not successful."

    assert_select "div#datepicker", true, "Datepicker did not appear."
    assert_select "div#Total", false, "User should not render other user tabs."
    sign_out user
  end

  test "show manager userpage" do
    user = User.where(:login => 'wayne.mitchell').first
    sign_in user
    get :show, params: {id: user.id}
    assert_response :success, "Route was not successful."

    assert_select "div#datepicker", true, "Datepicker did not appear."
    assert_select "div#Total", true, "User should not render other user tabs."
    sign_out user
  end
end
