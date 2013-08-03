require 'test_helper'

class WorkoutUnitTest < ActiveSupport::TestCase
  test "the truth" do
    # Few random spot checks on my fixtures
    assert_equal(1, workout_units(:workout_unit_1).id)
    assert_equal(4320, workout_units(:workout_unit_15).target_volume)
  end
  
  test "x_most_recent_for" do
    assert_equal(3, WorkoutUnit.x_most_recent_for(exercises(:two_arm_seated_dumbbell_extension).id, users(:jason).id).size)
  end
end
