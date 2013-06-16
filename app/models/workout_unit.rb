class WorkoutUnit < ActiveRecord::Base
  
  FAILURE_WORD = "fail"
  PASS_WORD    = "pass"
  HOLD_WORD    = "hold"

  REDUCE_WORD  = "reduce"
  ADVANCE_WORD = "advance"
  
  REQUIRE_NUM_OF_PASSES_TO_ADVANCE = 2
  REQUIRE_NUM_OF_FAILS_TO_REDUCE   = 1
  attr_accessible :exercise_id, :min_reps_set_1, :min_reps_set_2, :min_reps_set_3, :max_reps_set_1, :max_reps_set_2, :max_reps_set_3, :weight_1, :weight_2, :weight_3, :workout_id, :diff_1, :diff_2, :diff_3, :actual_reps_set_1, :actual_reps_set_2, :actual_reps_set_3, :user_id, :target_volume, :recommendation, :maxed_out_set_1, :maxed_out_set_2, :maxed_out_set_3, :lower_bound_met_set_1, :lower_bound_met_set_2, :lower_bound_met_set_3, :pass_counter, :hold_counter
  
  belongs_to :exercise
  belongs_to :workout
  belongs_to :user
  
  # This method is called once a workout is complete/submitted.  It reviews
  # the work done by the user, sets attributes used by our progression model,
  # and ultimately makes a recomendation on the users performance.
  #
  # @return [nil]
  def set_recommendation
    logger.debug "SETTING RECOMMENDATION!!!!!!!!!!!!!!"
    logger.debug actual_reps_set_1
    lower_bound_met_set_1 = ((actual_reps_set_1 || 0) >= min_reps_set_1)
    lower_bound_met_set_2 = ((actual_reps_set_2 || 0) >= min_reps_set_2)
    lower_bound_met_set_3 = ((actual_reps_set_3 || 0) >= min_reps_set_3)
    
    maxed_out_set_1 = ((actual_reps_set_1 || 0) >= max_reps_set_1)
    maxed_out_set_2 = ((actual_reps_set_2 || 0) >= max_reps_set_2)
    maxed_out_set_3 = ((actual_reps_set_3 || 0) >= max_reps_set_3)
    
    if maxed_out_set_1 && maxed_out_set_2 && maxed_out_set_3
      logger.debug "here1"
      recommendation = PASS_WORD
      self.pass_counter += 1
    elsif lower_bound_met_set_1 && lower_bound_met_set_2 && lower_bound_met_set_3
      logger.debug "here2"
      recommendation = HOLD_WORD
      self.hold_counter += 1
    else
      logger.debug "here3"
      recommendation = FAILURE_WORD
    end
    
    self.save
    
    # The old code that used to review whether or not a workout was achieved set
    # the follow variables.  self here references the workout object.  Should I
    # use these anymore?  Not sure yet, I think not, but hanging on to the code
    # just in case I want to review it later.
    #
    #self.update_attribute(:muscle_group_1_goal_achieved, mg1_achieved)
    #self.update_attribute(:muscle_group_2_goal_achieved, mg2_achieved)
    
  end
  
  def self.get_previous_weights(user_id, exercise_id)
    prev = self.where(:user_id => user_id).where(:exercise_id => exercise_id).order("workout_id DESC").first
    [prev.weight_1, prev.weight_2, prev.weight_3]
  end
  
  def self.get_weights(user_id, exercise_id)
    prev_weights     = get_previous_weights(user_id, exercise_id)
    phase            = get_phase(user_id, exercise_id)
    weight_intervals = Exercise.weight_interval(exercise_id)
    
    direction = HOLD_WORD
    if should_advance?(user_id, exercise_id)
      direction = ADVANCE_WORD
    elsif should_reduce?(user_id, exercise_id)
      logger.debug "RECOMENDING REDUCTION FOR #{exercise_id}"
      direction = REDUCE_WORD
    end
    
    adjust_weight_by_phase(prev_weights, weight_intervals, phase, direction)
  end
  
  def self.adjust_weight_by_phase(weights, weight_intervals, phase, direction)
    if direction == ADVANCE_WORD
      weights = case phase
        when 0 then [weights[0], weights[1], weights[2]+weight_intervals]
        when 1 then [weights[0], weights[1]+weight_intervals, weights[2]]
        when 2 then [weights[0]+weight_intervals, weights[1], weights[2]]
      end
    elsif direction == REDUCE_WORD
      logger.debug "SHOULD BE REDUCING WEIGHT BY #{weight_intervals}"
      logger.debug "ORIGINAL WEIGHT ARRAY: #{weights}"
      
      weights = case phase
        when 0 then [weights[0], weights[1], weights[2]-weight_intervals]
        when 1 then [weights[0], weights[1]-weight_intervals, weights[2]]
        when 2 then [weights[0]-weight_intervals, weights[1], weights[2]]
      end
      logger.debug "NEW WEIGHT ARRAY: #{weights}"
    end
    
    return weights
  end
  
  def self.get_phase(user_id, exercise_id)
    self.where(:user_id => user_id).where(:exercise_id => exercise_id).first.progression_phase
  end
  
  # Determines whether or not the user is prepared to advance in weight
  def self.should_advance?(user_id, exercise_id)
    last_workout_unit = self.where(:user_id => user_id).where(:exercise_id => exercise_id).order("id DESC").limit(1).first
    last_workout_unit.pass_counter >= REQUIRE_NUM_OF_PASSES_TO_ADVANCE
  end
  
  def self.should_reduce?(user_id, exercise_id)
    last_workout_unit = self.where(:user_id => user_id).where(:exercise_id => exercise_id).order("id DESC").limit(1).first    
    last_workout_unit.recommendation == FAILURE_WORD
  end
  
  # Returns the number of recent consecutive workout units achieved for the 
  # specified volumes and on a given exercise.  Achieved is defined as the
  # user having lifted at least as much volume as we requested for all three
  # sets.
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
      
      # Calculate the volume for each set and check that it matches with the specified volumes parameter
      match_1 = ((wu.actual_reps_set_1 || 0) * wu.weight_1) >= volumes[0]
      match_2 = ((wu.actual_reps_set_2 || 0) * wu.weight_2) >= volumes[1]
      match_3 = ((wu.actual_reps_set_3 || 0) * wu.weight_3) >= volumes[2]
      
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