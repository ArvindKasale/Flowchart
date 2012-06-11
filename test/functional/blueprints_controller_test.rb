require 'test_helper'

class BlueprintsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blueprints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blueprint" do
    assert_difference('Blueprint.count') do
      post :create, :blueprint => { }
    end

    assert_redirected_to blueprint_path(assigns(:blueprint))
  end

  test "should show blueprint" do
    get :show, :id => blueprints(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => blueprints(:one).to_param
    assert_response :success
  end

  test "should update blueprint" do
    put :update, :id => blueprints(:one).to_param, :blueprint => { }
    assert_redirected_to blueprint_path(assigns(:blueprint))
  end

  test "should destroy blueprint" do
    assert_difference('Blueprint.count', -1) do
      delete :destroy, :id => blueprints(:one).to_param
    end

    assert_redirected_to blueprints_path
  end
end
