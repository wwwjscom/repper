require 'test_helper'

class BetaCodesControllerTest < ActionController::TestCase
  setup do
    @beta_code = beta_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beta_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beta_code" do
    assert_difference('BetaCode.count') do
      post :create, beta_code: { assigned_to_email: @beta_code.assigned_to_email, code: @beta_code.code, used: @beta_code.used }
    end

    assert_redirected_to beta_code_path(assigns(:beta_code))
  end

  test "should show beta_code" do
    get :show, id: @beta_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beta_code
    assert_response :success
  end

  test "should update beta_code" do
    put :update, id: @beta_code, beta_code: { assigned_to_email: @beta_code.assigned_to_email, code: @beta_code.code, used: @beta_code.used }
    assert_redirected_to beta_code_path(assigns(:beta_code))
  end

  test "should destroy beta_code" do
    assert_difference('BetaCode.count', -1) do
      delete :destroy, id: @beta_code
    end

    assert_redirected_to beta_codes_path
  end
end
