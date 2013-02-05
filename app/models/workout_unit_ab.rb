class WorkoutUnitAb < ActiveRecord::Base
  attr_accessible :exercise_id, :reps, :workout_id, :actual_reps, :user_id
  
  belongs_to :exercise
  belongs_to :workout
  belongs_to :user
end
