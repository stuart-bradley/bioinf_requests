require 'test_helper'

class RequestDeleteTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in User.where(:login => 'wayne.mitchell').first
  end

  def teardown
    sign_out User.where(:login => 'wayne.mitchell').first
  end

  test "can delete a request" do
    request = Request.first

    delete "/requests/#{request.id}"
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal "The request #{request.title} has been deleted.", flash[:notice], "Flash notice did not appear."
  end
end
