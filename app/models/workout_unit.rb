class WorkoutUnit < ActiveRecord::Base
  attr_accessible :exercise_id, :rep_1, :rep_2, :rep_3, :weight_1, :weight_2, :weight_3, :workout_id, :diff_1, :diff_2, :diff_3, :actual_reps_1, :actual_reps_2, :actual_reps_3
  
  belongs_to :exercise
  belongs_to :workout
end
