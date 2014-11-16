require 'test_helper'

class ModellingsControllerTest < ActionController::TestCase
  setup do
    @modelling = modellings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:modellings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create modelling" do
    assert_difference('Modelling.count') do
      post :create, modelling: {  }
    end

    assert_redirected_to modelling_path(assigns(:modelling))
  end

  test "should show modelling" do
    get :show, id: @modelling
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @modelling
    assert_response :success
  end

  test "should update modelling" do
    patch :update, id: @modelling, modelling: {  }
    assert_redirected_to modelling_path(assigns(:modelling))
  end

  test "should destroy modelling" do
    assert_difference('Modelling.count', -1) do
      delete :destroy, id: @modelling
    end

    assert_redirected_to modellings_path
  end
end
