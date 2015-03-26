require 'test_helper'

class SketchHistoriesControllerTest < ActionController::TestCase
  setup do
    @sketch_history = sketch_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sketch_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sketch_history" do
    assert_difference('SketchHistory.count') do
      post :create, sketch_history: {  }
    end

    assert_redirected_to sketch_history_path(assigns(:sketch_history))
  end

  test "should show sketch_history" do
    get :show, id: @sketch_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sketch_history
    assert_response :success
  end

  test "should update sketch_history" do
    patch :update, id: @sketch_history, sketch_history: {  }
    assert_redirected_to sketch_history_path(assigns(:sketch_history))
  end

  test "should destroy sketch_history" do
    assert_difference('SketchHistory.count', -1) do
      delete :destroy, id: @sketch_history
    end

    assert_redirected_to sketch_histories_path
  end
end
