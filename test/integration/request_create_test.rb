require 'test_helper'

class RequestCreateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in User.where(:login => 'wayne.mitchell').first
  end

  def teardown
    sign_out User.where(:login => 'wayne.mitchell').first
  end

  test "can see the welcome page" do
    get "/"
    assert_select "table[id=?]", "main_table"
  end
end
