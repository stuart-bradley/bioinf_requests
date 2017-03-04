require 'test_helper'

class RequestUpdateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in User.where(:login => 'wayne.mitchell').first
  end

  def teardown
    sign_out User.where(:login => 'wayne.mitchell').first
  end

  test "can update a request" do
    request = Request.first
    get "/requests/#{request.id}/edit/"
    assert_response :success

    patch "/requests/#{request.id}", params: {request: {title: "updated"}}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal "The request updated has been updated.", flash[:notice], "Flash notice did not appear."
  end
end
