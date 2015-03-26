require 'test_helper'

class SketchesControllerTest < ActionController::TestCase
  setup do
    @sketch = sketches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sketches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sketch" do
    assert_difference('Sketch.count') do
      post :create, sketch: {  }
    end

    assert_redirected_to sketch_path(assigns(:sketch))
  end

  test "should show sketch" do
    get :show, id: @sketch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sketch
    assert_response :success
  end

  test "should update sketch" do
    patch :update, id: @sketch, sketch: {  }
    assert_redirected_to sketch_path(assigns(:sketch))
  end

  test "should destroy sketch" do
    assert_difference('Sketch.count', -1) do
      delete :destroy, id: @sketch
    end

    assert_redirected_to sketches_path
  end
end
