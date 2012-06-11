require 'test_helper'

class MasterMapsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:master_maps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create master_map" do
    assert_difference('MasterMap.count') do
      post :create, :master_map => { }
    end

    assert_redirected_to master_map_path(assigns(:master_map))
  end

  test "should show master_map" do
    get :show, :id => master_maps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => master_maps(:one).to_param
    assert_response :success
  end

  test "should update master_map" do
    put :update, :id => master_maps(:one).to_param, :master_map => { }
    assert_redirected_to master_map_path(assigns(:master_map))
  end

  test "should destroy master_map" do
    assert_difference('MasterMap.count', -1) do
      delete :destroy, :id => master_maps(:one).to_param
    end

    assert_redirected_to master_maps_path
  end
end
