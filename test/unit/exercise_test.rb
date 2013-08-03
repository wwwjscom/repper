require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase

  test "weight interval" do
    assert_equal(10, Exercise.weight_interval(exercises(:row_machine)))
  end
  
  test "rounding to a doable weight" do
    assert_equal(60, Exercise.round_up_to_doable_weight(exercises(:row_machine), 54.5))
    assert_equal(60, Exercise.round_up_to_doable_weight(exercises(:row_machine), 50.001))
    assert_equal(60, Exercise.round_up_to_doable_weight(exercises(:row_machine), 59.99))
  end
  
  test "new 1RM" do
    recent_wus = WorkoutUnit.x_most_recent_for(exercises(:two_arm_seated_dumbbell_extension).id, users(:jason).id)
    # current 1RM is 42.0
    assert_equal(34.277777777777786, Exercise.new_1RM(recent_wus))
  end
end