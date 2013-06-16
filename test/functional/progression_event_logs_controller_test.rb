require 'test_helper'

class ProgressionEventLogsControllerTest < ActionController::TestCase
  setup do
    @progression_event_log = progression_event_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:progression_event_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create progression_event_log" do
    assert_difference('ProgressionEventLog.count') do
      post :create, progression_event_log: { exercise_id: @progression_event_log.exercise_id, new_1RM: @progression_event_log.new_1RM, progression_outcome: @progression_event_log.progression_outcome, user_id: @progression_event_log.user_id, workout_unit_id: @progression_event_log.workout_unit_id }
    end

    assert_redirected_to progression_event_log_path(assigns(:progression_event_log))
  end

  test "should show progression_event_log" do
    get :show, id: @progression_event_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @progression_event_log
    assert_response :success
  end

  test "should update progression_event_log" do
    put :update, id: @progression_event_log, progression_event_log: { exercise_id: @progression_event_log.exercise_id, new_1RM: @progression_event_log.new_1RM, progression_outcome: @progression_event_log.progression_outcome, user_id: @progression_event_log.user_id, workout_unit_id: @progression_event_log.workout_unit_id }
    assert_redirected_to progression_event_log_path(assigns(:progression_event_log))
  end

  test "should destroy progression_event_log" do
    assert_difference('ProgressionEventLog.count', -1) do
      delete :destroy, id: @progression_event_log
    end

    assert_redirected_to progression_event_logs_path
  end
end
