require 'test_helper'

class RequestCreateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in User.where(:login => 'wayne.mitchell').first
  end

  def teardown
    sign_out User.where(:login => 'wayne.mitchell').first
  end

  test "can create an request" do
    get "/requests/new"
    assert_response :success

    post "/requests", {request: {id: (Request.last.id + 1), title: 'New Request', name: 'stuart.bradley'}}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal "The request New Request has been created.", flash[:notice], "Flash notice did not appear."
  end
end
