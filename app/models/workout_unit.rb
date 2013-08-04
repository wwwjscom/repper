class WorkoutUnit < ActiveRecord::Base
  attr_accessible :exercise_id, :min_reps_set_1, :min_reps_set_2, :min_reps_set_3, :max_reps_set_1, :max_reps_set_2, :max_reps_set_3, :weight_1, :weight_2, :weight_3, :workout_id, :diff_1, :diff_2, :diff_3, :actual_reps_set_1, :actual_reps_set_2, :actual_reps_set_3, :user_id, :target_volume, :recommendation, :maxed_out_set_1, :maxed_out_set_2, :maxed_out_set_3, :lower_bound_met_set_1, :lower_bound_met_set_2, :lower_bound_met_set_3, :pass_counter, :hold_counter, :submitted, :eligible_for_evaluation, :progression_phase
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
  
  # Returns whether this workout unit is eligible for evaluation.  Workout units
  # may not be eligible for evaluation because the user is not lifting at their
  # max percentage of the 1RM (for example, 80% of 1RM).  As such, we don't want
  # to evaluate these workouts because they going to give us incomplete information
  # about a users strengths/weaknesses.
  #
  # @return [Boolean]
  def not_eligible_for_evaluation?
    !eligible_for_evaluation
  end
  
  
  # This method is called once a workout is complete/submitted.  It reviews
  # the work done by the user, sets attributes used by our progression model,
  # and ultimately makes a recomendation on the users performance.
  #
  # @return [nil]
  def set_recommendation
    set_lower_bounds
    set_maxed_out
    
    if not_eligible_for_evaluation?
      # Don't do anything.  We aren't concerned with the user's performance.
    elsif maxed_out?
      WorkoutUnit.pass_user(self)
    elsif met_all_lower_bounds?
      WorkoutUnit.hold_user(self)
    else
      WorkoutUnit.fail_user(self)
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
  
  # Checks if the user maxed out the number of reps for each set of this wu.
  # @return [Boolean] whether the user maxed out the reps
  def maxed_out?
    (maxed_out_set_1 && maxed_out_set_2 && maxed_out_set_3)
  end
  
  # Checks if the user did the min number of reps for each set of this wu.
  # @return [Boolean] whether the users did all the min reps required
  def met_all_lower_bounds?
    (lower_bound_met_set_1 && lower_bound_met_set_2 && lower_bound_met_set_3)
  end
  
  # Checks if the user met the lower bounds for all the exercises and 
  # sets the variables accordingly.
  def set_lower_bounds
    self.lower_bound_met_set_1 = ((actual_reps_set_1 || 0) >= min_reps_set_1)
    self.lower_bound_met_set_2 = ((actual_reps_set_2 || 0) >= min_reps_set_2)
    self.lower_bound_met_set_3 = ((actual_reps_set_3 || 0) >= min_reps_set_3)
  end
  
  # Checks if the users maxed out the number of reps for each set and
  # sets the variables accordingly.
  def set_maxed_out
    self.maxed_out_set_1 = ((actual_reps_set_1 || 0) >= max_reps_set_1)
    self.maxed_out_set_2 = ((actual_reps_set_2 || 0) >= max_reps_set_2)
    self.maxed_out_set_3 = ((actual_reps_set_3 || 0) >= max_reps_set_3)
  end
  
  # Returns the 3 most recent workout that are eligible_for_evaluation and are units for a 
  # particular exercise.  This is used for calculating a new 1RM.  I figure using a sample 
  # size of 3 workout units to calculate the new 1RM is probably good enough.
  #
  # Note that it's possible for this array to contain nils.  This would occur if the
  # user does not have a history of at least 3 workout units for this exercise.
  #
  # @param exercise_id [Integer] exercise scope
  # @param user_id [Integer] user scope
  # @param count [Integer] The number of workout units to retrieve
  # @return [Array<WorkoutUnit>] of the 3 most recent workout units for this exercise and user.
  def self.x_most_recent_for(exercise_id, user_id, count = 3)
    WorkoutUnit.where(:eligible_for_evaluation => true).where(:exercise_id => exercise_id).where(:user_id => user_id).order("id DESC").limit(count)
  end
  
  # Do all required things to pass the user for a specific wu
  # @param wu [WorkoutUnit] The workout unit associated with this event
  def self.pass_user(wu)
    wu.recommendation = PASS_WORD
    wu.pass_counter += 1
    recent_wus = WorkoutUnit.x_most_recent_for(wu.exercise_id, wu.user_id)
    new_1RM = Exercise.new_1RM(recent_wus)
    ProgressionEventLog.passed(wu, new_1RM)
  end

  # Do all required things to hold the user for a specific wu
  # @param wu [WorkoutUnit] The workout unit associated with this event  
  def self.hold_user(wu)
    wu.recommendation = HOLD_WORD
    wu.hold_counter += 1
  end
  
  # Do all required things to fail the user for a specific wu
  # @param wu [WorkoutUnit] The workout unit associated with this event
  def self.fail_user(wu)
    wu.recommendation = FAILURE_WORD   
    recent_wus = WorkoutUnit.x_most_recent_for(wu.exercise_id, wu.user_id)
    new_1RM = Exercise.new_1RM(recent_wus)   
    ProgressionEventLog.failed(wu, new_1RM)
  end
  
  
  # Returns all the weights as an array
  # @return [Array] of all the weights
  def weights
    [weight_1, weight_2, weight_3]
  end
  
  # Sets the weight for the WorkoutUnit based on the users evaluation.  This
  # can be used in situations where the user is doing an exercise they've never
  # done before, or if we have no useable history to evaluate the user on to
  # determine what weight they should be lifting.
  #
  # @param percent_of_1RM [Float] Percentage of the 1RM that the user should be
  #  be lifting.  This will be the max weight they perform for this exercise.
  #  The number will also be adjusted so that it is doable for the exercise.
  #  Example: 0.8 for 80%
  def set_weights_based_on_evaluation(percent_of_1RM)
    weight_max        = self.exercise.weight_adjustment * self.user.evaluations.last.one_rep_max(self.exercise.muscle_group.name.to_sym, percent_of_1RM)
    doable_max_weight = Exercise.round_up_to_doable_weight(exercise.id, weight_max)
    self.weight_1     = doable_max_weight - self.exercise.weight_interval*2
    self.weight_2     = doable_max_weight - self.exercise.weight_interval
    self.weight_3     = doable_max_weight
  end
  
  # This method is used when creating a new workout.  It sets the weights
  # to be used for the workout unit based on the user's past performance.
  # 
  # The suggested weight is automatically set on the WorkoutUnit object.  
  #
  # @return [WorkoutUnit] with weights set
  def set_weights
    weight_intervals = Exercise.weight_interval(exercise_id)
    direction        = HOLD_WORD
    prev_weights     = prev.weights 
    
    if should_advance?
      # If they have completed at least x of these exercises, and
      # they have maxed out REQUIRE_NUM_OF_PASSES_TO_ADVANCE, then
      # allow their weight to increase.
      direction = ADVANCE_WORD
      reset_counters
    elsif should_reduce?
      # If their previous workout recomended they decrease their
      # weight, then decrease it.
      direction = REDUCE_WORD
      reset_counters
    end
    
    weights       = adjust_weight_by_phase(prev_weights, weight_intervals, progression_phase, direction)
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
  
  # Returns the previous WorkoutUnit for a particular user and exercise.  By default
  # it is scoped to only return workout units that are eligible_for_evaluation.
  #
  # @param eligible_only [Boolean] Only return workout units that are eligible_for_evaluation
  # @return [WorkoutUnit] for previous time this exercise was performed by this user.  If no
  #  prev workout unit exists, nil is returned.
  def prev(eligible_only = true)
    WorkoutUnit.where(:eligible_for_evaluation => eligible_only).where(:user_id => user_id).where(:exercise_id => exercise_id).where("id < ?", (id || 99999999999999)).order("id DESC").first
  end
  
  # This is where the weights are adjusted for a workout.  The weights
  # are adjusted on the WorkoutUnit itself, thus nothing is returned.
  #
  # FIXME: It'd be best if these weights were set based on the users
  # historical 1RM rather than just adjusting the weights by a fixed
  # value each time.  Bug #44.
  #
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
  
  # Determines whether or not the user is prepared to advance in weight.
  # Note we do not advance a user until they have at least 3 workout units
  # for us to evaluate.
  # @return [Boolean]
  def should_advance?
    WorkoutUnit.x_most_recent_for(self.exercise_id, self.user_id).size >= 3 && prev.pass_counter >= REQUIRE_NUM_OF_PASSES_TO_ADVANCE
  end
  
  # Determines whether a users should reduce their weight.
  # @return [Boolean]
  def should_reduce?
    prev.recommendation == FAILURE_WORD
  end
  
end