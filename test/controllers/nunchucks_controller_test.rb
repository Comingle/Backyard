require 'test_helper'

class NunchucksControllerTest < ActionController::TestCase
  setup do
    @nunchuck = nunchucks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nunchucks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nunchuck" do
    assert_difference('Nunchuck.count') do
      post :create, nunchuck: {  }
    end

    assert_redirected_to nunchuck_path(assigns(:nunchuck))
  end

  test "should show nunchuck" do
    get :show, id: @nunchuck
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nunchuck
    assert_response :success
  end

  test "should update nunchuck" do
    patch :update, id: @nunchuck, nunchuck: {  }
    assert_redirected_to nunchuck_path(assigns(:nunchuck))
  end

  test "should destroy nunchuck" do
    assert_difference('Nunchuck.count', -1) do
      delete :destroy, id: @nunchuck
    end

    assert_redirected_to nunchucks_path
  end
end
