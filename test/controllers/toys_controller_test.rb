require 'test_helper'

class ToysControllerTest < ActionController::TestCase
  setup do
    @toy = toys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:toys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create toy" do
    assert_difference('Toy.count') do
      post :create, toy: {  }
    end

    assert_redirected_to toy_path(assigns(:toy))
  end

  test "should show toy" do
    get :show, id: @toy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @toy
    assert_response :success
  end

  test "should update toy" do
    patch :update, id: @toy, toy: {  }
    assert_redirected_to toy_path(assigns(:toy))
  end

  test "should destroy toy" do
    assert_difference('Toy.count', -1) do
      delete :destroy, id: @toy
    end

    assert_redirected_to toys_path
  end
end
