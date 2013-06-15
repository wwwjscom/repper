class WorkoutUnit < ActiveRecord::Base
  attr_accessible :exercise_id, :rep_1, :rep_2, :rep_3, :weight_1, :weight_2, :weight_3, :workout_id, :diff_1, :diff_2, :diff_3, :actual_reps_1, :actual_reps_2, :actual_reps_3, :user_id, :perodize_phase, :target_volume
  
  belongs_to :exercise
  belongs_to :workout
  belongs_to :user
  
  # Returns the number of recent consecutive workout units achieved for the 
  # specified volumes and on a given exercise.
  #
  # @param volumes [Array] The target volumes for each set
  # @param exercise_id [Integer] The exercise id of interest
  # @param user_id [Integer] The user we're scoped on
  # @param current_workout_id [Integer] If specified, this workout it will be ignored.
  #  This is useful for cases where you are in the middle of a workout and want to calculate
  #  all prior successful cases.
  # @return [Integer] The number of times we have seen this
  #  exercise completed with these target volumes
  def self.achieved_at_target_volume(volumes, exercise_id, user_id, current_workout_id = Float::INFINITY)
    match_count = 0
    workout_units = self.where(:user_id => user_id).where(:exercise_id => exercise_id).where("'workout_units'.'workout_id' < ?", current_workout_id).order("id DESC")
    workout_units.each do |wu|
      next if wu.workout_id == current_workout_id

      # If any of the actual reps are nil, we presume the user did not perform this workout.
      break unless wu.actual_reps_1 && wu.actual_reps_2 && wu.actual_reps_3
      
      # Calculate the volume for each set and check that it matches with the
      # specified volumes parameter
      match_1 = (wu.actual_reps_1 * wu.weight_1) >= volumes[0]
      match_2 = (wu.actual_reps_2 * wu.weight_2) >= volumes[1]
      match_3 = (wu.actual_reps_3 * wu.weight_3) >= volumes[2]
      
      # Break on the first instance where the user failed to meet the exercise goal.
      # We do this since we are only concerned with consecutive successes.
      break unless match_1 && match_2 && match_3      
      
      # If we made it here, then the user did the required number of reps, so
      # increment the match counter
      match_count += 1 
    end
    
    return match_count
  end
  
end