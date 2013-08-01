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
end