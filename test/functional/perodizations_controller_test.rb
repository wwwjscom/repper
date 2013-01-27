require 'test_helper'

class PerodizationsControllerTest < ActionController::TestCase
  setup do
    @perodization = perodizations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:perodizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create perodization" do
    assert_difference('Perodization.count') do
      post :create, perodization: { muscle_group_id: @perodization.muscle_group_id, perodization_phase: @perodization.perodization_phase, user_id: @perodization.user_id }
    end

    assert_redirected_to perodization_path(assigns(:perodization))
  end

  test "should show perodization" do
    get :show, id: @perodization
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @perodization
    assert_response :success
  end

  test "should update perodization" do
    put :update, id: @perodization, perodization: { muscle_group_id: @perodization.muscle_group_id, perodization_phase: @perodization.perodization_phase, user_id: @perodization.user_id }
    assert_redirected_to perodization_path(assigns(:perodization))
  end

  test "should destroy perodization" do
    assert_difference('Perodization.count', -1) do
      delete :destroy, id: @perodization
    end

    assert_redirected_to perodizations_path
  end
end
