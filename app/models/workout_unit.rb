class WorkoutUnit < ActiveRecord::Base
  attr_accessible :exercise_id, :min_reps_set_1, :min_reps_set_2, :min_reps_set_3, :max_reps_set_1, :max_reps_set_2, :max_reps_set_3, :weight_1, :weight_2, :weight_3, :workout_id, :diff_1, :diff_2, :diff_3, :actual_reps_set_1, :actual_reps_set_2, :actual_reps_set_3, :user_id, :target_volume, :recommendation, :maxed_out_set_1, :maxed_out_set_2, :maxed_out_set_3, :lower_bound_met_set_1, :lower_bound_met_set_2, :lower_bound_met_set_3, :pass_counter, :hold_counter
  belongs_to :exercise
  belongs_to :workout
  belongs_to :user
  
  FAILURE_WORD = "fail"
  PASS_WORD    = "pass"
  HOLD_WORD    = "hold"

  REDUCE_WORD  = "reduce"
  ADVANCE_WORD = "advance"
  
  # Changing these numbers will change the number of times a users must either
  # successfully complete a workout unit in order to advance, or fail a workout
  # unit in order to have their weight reduced.
  REQUIRE_NUM_OF_PASSES_TO_ADVANCE = 2
  REQUIRE_NUM_OF_FAILS_TO_REDUCE   = 1  
  
  # This method is called once a workout is complete/submitted.  It reviews
  # the work done by the user, sets attributes used by our progression model,
  # and ultimately makes a recomendation on the users performance.
  #
  # @return [nil]
  def set_recommendation
    self.lower_bound_met_set_1 = ((actual_reps_set_1 || 0) >= min_reps_set_1)
    self.lower_bound_met_set_2 = ((actual_reps_set_2 || 0) >= min_reps_set_2)
    self.lower_bound_met_set_3 = ((actual_reps_set_3 || 0) >= min_reps_set_3)
    
    self.maxed_out_set_1 = ((actual_reps_set_1 || 0) >= max_reps_set_1)
    self.maxed_out_set_2 = ((actual_reps_set_2 || 0) >= max_reps_set_2)
    self.maxed_out_set_3 = ((actual_reps_set_3 || 0) >= max_reps_set_3)
    
    if maxed_out_set_1 && maxed_out_set_2 && maxed_out_set_3
      logger.debug "here1"
      self.recommendation = PASS_WORD
      self.pass_counter += 1
    elsif lower_bound_met_set_1 && lower_bound_met_set_2 && lower_bound_met_set_3
      logger.debug "here2"
      self.recommendation = HOLD_WORD
      self.hold_counter += 1
    else
      logger.debug "here3"
      self.recommendation = FAILURE_WORD
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
  
  # Returns all the weights as an array
  # @return [Array] of all the weights
  def weights
    [weight_1, weight_2, weight_3]
  end
  
  # Contains the logic to decide whether to advance, reduce, or hold a
  # users weight.  Automatically sets the weights accordingly on the
  # WorkoutUnit object.  Also resets relevant counters.
  # @return [WorkoutUnit] with weights set
  def set_weights
    weight_intervals       = Exercise.weight_interval(exercise_id)
    prev_weights           = prev.weights
    self.progression_phase = prev.progression_phase
    self.pass_counter      = prev.pass_counter
    self.hold_counter      = prev.hold_counter
    
    direction = HOLD_WORD
    if should_advance?
      direction = ADVANCE_WORD
      reset_counters
    elsif should_reduce?
      direction = REDUCE_WORD
      reset_counters
    end
    
    weights  = adjust_weight_by_phase(prev_weights, weight_intervals, progression_phase, direction)
    self.weight_1 = weights[0]
    self.weight_2 = weights[1]
    self.weight_3 = weights[2]
    self
  end
  
  # Resets various counters
  def reset_counters
   self.pass_counter = 0
   self.hold_counter = 0
  end
  
  # Returns the previous WorkoutUnit for a particular user and exercise.
  # @return [WorkoutUnit] for previous time this exercise was performed by this user
  def prev
    WorkoutUnit.where(:user_id => user_id).where(:exercise_id => exercise_id).where("id < ?", (id || 99999999999999)).order("id DESC").first
  end
  
  # This is where the weights are adjusted for a workout.  The weights
  # are adjusted on the WorkoutUnit itself, thus nothing is returned.
  # @return [nil]
  def adjust_weight_by_phase(weights, weight_intervals, phase, direction)
    if direction == ADVANCE_WORD
      weights = case phase
        when 0 then [weights[0], weights[1], weights[2]+weight_intervals]
        when 1 then [weights[0], weights[1]+weight_intervals, weights[2]]
        when 2 then [weights[0]+weight_intervals, weights[1], weights[2]]
      end
      self.progression_phase = (self.progression_phase + 1) % 3
    elsif direction == REDUCE_WORD
      weights = case phase
        when 0 then [weights[0], weights[1], weights[2]-weight_intervals]
        when 1 then [weights[0], weights[1]-weight_intervals, weights[2]]
        when 2 then [weights[0]-weight_intervals, weights[1], weights[2]]
      end
      self.progression_phase = (self.progression_phase + 2) % 3 # subtracts one from the phase basically
    end
    
    return weights
  end
  
  # Determines whether or not the user is prepared to advance in weight
  # @return [Boolean]
  def should_advance?
    prev.pass_counter >= REQUIRE_NUM_OF_PASSES_TO_ADVANCE
  end
  
  # Determines whether a users should reduce their weight.
  # @return [Boolean]
  def should_reduce?
    prev.recommendation == FAILURE_WORD
  end
  
end