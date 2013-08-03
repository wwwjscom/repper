class ProgressionEventLog < ActiveRecord::Base
  # new_1RM is calculated using, at most, the 3 most recent results for this exercise.
  attr_accessible :exercise_id, :new_1RM, :progression_outcome, :user_id, :workout_unit_id
  
  belongs_to :exercise
  belongs_to :user
  belongs_to :workout_unit
  
  # Create a new ProgressionEventLog using the given in WorkoutUnit
  # and set it showing that the user has passed.
  def self.passed(wu, new_1RM)
    pel = ProgressionEventLog.create(
      :workout_unit_id     => wu.id,
      :progression_outcome => WorkoutUnit::PASS_WORD,
      :user_id             => wu.user_id,
      :exercise_id         => wu.exercise_id,
      :new_1RM             => new_1RM
    )
  end
  
  # Create a new ProgressionEventLog using the given in WorkoutUnit
  # and set it showing that the user has failed.
  def self.failed(wu, new_1RM)
    pel = ProgressionEventLog.create(
      :workout_unit_id     => wu.id,
      :progression_outcome => WorkoutUnit::FAILURE_WORD,
      :user_id             => wu.user_id,
      :exercise_id         => wu.exercise_id,
      :new_1RM             => new_1RM
    )
  end
  
end
