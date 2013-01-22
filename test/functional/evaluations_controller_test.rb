require 'test_helper'

class EvaluationsControllerTest < ActionController::TestCase
  setup do
    @evaluation = evaluations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation" do
    assert_difference('Evaluation.count') do
      post :create, evaluation: { arms_reps: @evaluation.arms_reps, arms_weight: @evaluation.arms_weight, back_reps: @evaluation.back_reps, back_weight: @evaluation.back_weight, chest_reps: @evaluation.chest_reps, chest_weight: @evaluation.chest_weight, crunch_reps: @evaluation.crunch_reps, legs_reps: @evaluation.legs_reps, legs_weight: @evaluation.legs_weight, should_reps: @evaluation.should_reps, shoulder_weight: @evaluation.shoulder_weight, user_id: @evaluation.user_id }
    end

    assert_redirected_to evaluation_path(assigns(:evaluation))
  end

  test "should show evaluation" do
    get :show, id: @evaluation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @evaluation
    assert_response :success
  end

  test "should update evaluation" do
    put :update, id: @evaluation, evaluation: { arms_reps: @evaluation.arms_reps, arms_weight: @evaluation.arms_weight, back_reps: @evaluation.back_reps, back_weight: @evaluation.back_weight, chest_reps: @evaluation.chest_reps, chest_weight: @evaluation.chest_weight, crunch_reps: @evaluation.crunch_reps, legs_reps: @evaluation.legs_reps, legs_weight: @evaluation.legs_weight, should_reps: @evaluation.should_reps, shoulder_weight: @evaluation.shoulder_weight, user_id: @evaluation.user_id }
    assert_redirected_to evaluation_path(assigns(:evaluation))
  end

  test "should destroy evaluation" do
    assert_difference('Evaluation.count', -1) do
      delete :destroy, id: @evaluation
    end

    assert_redirected_to evaluations_path
  end
end
