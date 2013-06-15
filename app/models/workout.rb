class Workout < ActiveRecord::Base
  attr_accessible :user_id, :muscle_group_1_id, :muscle_group_2_id, :workout_units_attributes, :perodize_phase, :workout_unit_abs_attributes, :mg1_phase_attempt_counter, :mg2_phase_attempt_counter, :mg1_perodize_phase, :mg2_perodize_phase
  has_many :workout_units, :dependent    => :delete_all
  has_many :workout_unit_abs, :dependent => :destroy
  accepts_nested_attributes_for :workout_units
  accepts_nested_attributes_for :workout_unit_abs
  belongs_to :user
    
  # Reorders the workout units so that the same muscle group isn't
  # in a row (if possible)
  # 
  # Returns
  #   An array of Workout Units
  def workout_units
    wus = WorkoutUnit.where(:workout_id => self.id).order("id DESC")

    # No reordering to be done -- onyl one muscle group being worked
    return wus if muscle_group_2_id == nil

    # Track the last workout unit muscle group id
    reordered_wus = Array.new(wus.size, nil)
    i = 0
    
    wus.each do |wu|
      next unless wu.exercise.muscle_group_id == muscle_group_1_id
      reordered_wus[i] = wu
      i += 2
    end

    i = 1
    wus.each do |wu|
      next unless wu.exercise.muscle_group_id == muscle_group_2_id
      reordered_wus[i] = wu
      i += 2
    end

    # Nils can make their way in if there is an unequal number of
    # exercises from each muscle group.  So, squash them.
    reordered_wus.delete_if { |x| x == nil }
  end
  
  def self.generate(user)
    # First, we need to know what areas the user is targeting
    target_groups = []
    _muscle_groups, construct_an_abs_workout = determine_muscle_groups_to_workout(user)
    logger.debug "User wants to workout abs: #{construct_an_abs_workout}"
    _muscle_groups.each do |mg|
      target_groups << {:muscle_group => mg}
    end
        
    logger.debug "tg: #{target_groups.inspect}"
    
    # Next we need to get the exercises for that area
    target_groups.each do |tg|
      tg[:exercises] = get_exercises_for_target_group(tg[:muscle_group].id)
    end
    logger.debug "tg: #{target_groups.inspect}"
    
    
    # Next we determine the weight, reps, sets, rest and velocity.  
    # This depends on the users exp, goal, exercise, 
    target_groups.each do |tg|
      # Grab the last perodize phase for this muscle group
      tg[:last_perodize_phase] = user.muscle_groups_users.where(:muscle_group_id => tg[:muscle_group].id).limit(1).first.perodize_phase
      tg[:next_perodize_phase] = tg[:last_perodize_phase]
      
      # Grab the last workout where this user worked this muscle group
      workout = user.workouts.where("muscle_group_1_id = ? OR muscle_group_2_id = ?", tg[:muscle_group].id, tg[:muscle_group].id).order("id DESC").limit(1).first
      # Was the workout goal achieved for this muscle group?
      if !workout.blank? && workout.goal_achieved?(tg[:muscle_group].id)
          tg[:next_perodize_phase] += 1
          
          if tg[:next_perodize_phase] > Perodization::MAX_PHASE
            # FIXME: This user needs to graduate to a large weight
            # since they finished a perodization cycle.  Add that logic!!!
            # For now, just set them back to phase 1 with no weight increase
            tg[:next_perodize_phase] = 1
          end
          
          # FIXME: Known bug: If the user generates a workout, then deletes it immediately
          # and generates another workout with that same muscle group, their perodize phase
          # will keep incrementing, so long as their last workout for that muscle group had
          # goals that were achieved.  i.e. the user could keep progressing without ever
          # doing any work...
          #
          # This line is to increment the perodize phase if the previous workout for this
          # muscle group was successful
          MuscleGroupsUser.find(user.muscle_groups_users.where(:muscle_group_id => tg[:muscle_group].id).limit(1).first.id).update_attribute(:perodize_phase, tg[:next_perodize_phase])
          
          # Since the goal was achieved reset the phase attempt counter to 1
          user.muscle_groups_users.find_by_muscle_group_id(tg[:muscle_group].id).update_attribute(:phase_attempt_counter, 1)
          
        elsif !workout.blank? && !workout.goal_achieved?(tg[:muscle_group].id)
          # If the workout goal was not achieved, incrememnt the phase attempt counter
          user.muscle_groups_users.find_by_muscle_group_id(tg[:muscle_group].id).increment!(:phase_attempt_counter)
      end
    end
    
    perodize_workout = []
    target_groups.each do |tg|
      tg[:exercises].each do |e|
        reps_and_weight, difficulity, target_volume = perodize_exercise_info(e, user, tg[:next_perodize_phase])
        perodize_workout << { :exercise            => e, 
                              :reps_and_weight     => reps_and_weight,
                              :difficulity         => difficulity,
                              :next_perodize_phase => tg[:next_perodize_phase],
                              :target_volume       => target_volume
                            }
      end    
    end
    
    # Now create the workout    
    w = Workout.create(
      :user_id           => user.id, 
      :muscle_group_1_id => target_groups[0][:muscle_group].id, 
      :muscle_group_2_id => target_groups[1][:muscle_group].id,
      :mg1_phase_attempt_counter => user.muscle_groups_users.find_by_muscle_group_id(target_groups[0][:muscle_group].id).phase_attempt_counter,
      :mg2_phase_attempt_counter => user.muscle_groups_users.find_by_muscle_group_id(target_groups[1][:muscle_group].id).phase_attempt_counter,
      :mg1_perodize_phase => user.muscle_groups_users.find_by_muscle_group_id(target_groups[0][:muscle_group].id).perodize_phase,
      :mg2_perodize_phase => user.muscle_groups_users.find_by_muscle_group_id(target_groups[1][:muscle_group].id).perodize_phase
    )

    perodize_workout.each do |pw|
      logger.debug "Creating a new perodize workout: #{pw.inspect}"
      WorkoutUnit.create(
      :user_id        => user.id,
      :workout_id     => w.id, 
      :perodize_phase => pw[:next_perodize_phase],
      :exercise_id    => pw[:exercise].id, 
      :rep_1          => pw[:reps_and_weight][0][:reps],
      :weight_1       => pw[:reps_and_weight][0][:weight],
      :diff_1         => pw[:difficulity],
      :rep_2          => pw[:reps_and_weight][1][:reps],
      :weight_2       => pw[:reps_and_weight][1][:weight],
      :diff_2         => pw[:difficulity],
      :rep_3          => pw[:reps_and_weight][2][:reps],
      :weight_3       => pw[:reps_and_weight][2][:weight],
      :diff_3         => pw[:difficulity],
      :target_volume  => pw[:target_volume]
      )
    end
    
    # Workout the abs?
    if construct_an_abs_workout
      logger.debug "Constructing abs workout"
      WorkoutUnitAb.generate_abs_workout(user).each do |exercise_and_reps_hash|
        logger.debug "Adding #{exercise_and_reps_hash.inspect}"
        WorkoutUnitAb.create(
          :user_id     => user.id,
          :exercise_id => exercise_and_reps_hash[:exercise].id,
          :reps        => exercise_and_reps_hash[:reps],
          :workout_id  => w.id 
        )
      end
    end
    
    return w
  end
  
  # Check to see if the goal was achieved for this particular
  # muscle group
  def goal_achieved?(muscle_group_id)
    achieved = false
    if muscle_group_1_id == muscle_group_id
      achieved = true if muscle_group_1_goal_achieved == 1
    elsif muscle_group_2_id == muscle_group_id
      achieved = true if muscle_group_2_goal_achieved == 1      
    end
    achieved
  end
  
  # Check that all exercises from each mg had the desired reps  
  def check_if_goals_achieved
    # Mark these as true to start.  If we find any reps that were
    # less than the target, mark it as false.
    mg1_achieved = 1
    mg2_achieved = 1
    
    workout_units.each do |wu|
      logger.debug "Checking #{wu.exercise.name}"
      if wu.exercise.muscle_group.id == muscle_group_1_id && (wu.rep_1.to_i > wu.actual_reps_1.to_i || wu.rep_2.to_i > wu.actual_reps_2.to_i || wu.rep_3.to_i > wu.actual_reps_3.to_i)
        logger.debug "Failed 1: #{wu.exercise.name}"
        mg1_achieved = 0
      elsif wu.exercise.muscle_group.id == muscle_group_2_id && (wu.rep_1.to_i > wu.actual_reps_1.to_i || wu.rep_2.to_i > wu.actual_reps_2.to_i || wu.rep_3.to_i > wu.actual_reps_3.to_i)
        logger.debug "Failed 2: #{wu.exercise.name}"
        mg2_achieved = 0
      end
    end
    self.update_attribute(:muscle_group_1_goal_achieved, mg1_achieved)
    self.update_attribute(:muscle_group_2_goal_achieved, mg2_achieved)
  end
  
  
  
  private
  
  def self.calc_volume(reps_and_weights)
    volume = 0
    3.times do |i|
      volume += (reps_and_weights[i][:reps] || 0) * (reps_and_weights[i][:weight] || 0)
    end
    volume
  end
  
  def self.perodize_exercise_info(exercise, user, next_perodize_phase)

    user_experience = user.experience
    user_past_workout_units = user.workout_units
    user_goal = user.goal
    
    info = {}
    case user_experience
      when 0 then
        case user_goal.downcase
          when "muscle gain" then info   = { :reps => 8..12, :load => 0.50..0.60, :sets => 1..3, :rest => 2..3, :velocity => "slow" }
          when "strength gain" then info = { :reps => 8..12, :load => 0.50..0.60, :sets => 1..3, :rest => 2..3, :velocity => "slow" }
        end
      when 1 then
        case user_goal.downcase
          when "muscle gain" then info   = { :reps => 8..12, :load => 0.65..0.75, :sets => 1..3, :rest => 1..2, :velocity => "slow and moderate" }
          when "strength gain" then info = { :reps => 8..12, :load => 0.60..0.70, :sets => 1..3, :rest => 2..3, :velocity => "slow" }
        end
      when 2 then
        case user_goal.downcase
          when "muscle gain" then info   = { :reps => 8..12, :load => 0.70..0.85, :sets => 1..3, :rest => 2..3, :velocity => "slow and moderate" }
          when "strength gain" then info = { :reps => 1..12, :load => 0.70..0.85, :sets => 1..3, :rest => 2..3, :velocity => "slow and moderate" }
        end
      when 3 then
        case user_goal.downcase
          when "muscle gain" then info   = { :reps => 8..12, :load => 0.70..0.100, :sets => 3..6, :rest => 2..3, :velocity => "all varying" }
          when "strength gain" then info = { :reps => 8..12, :load => 0.70..0.100, :sets => 3..6, :rest => 2..3, :velocity => "slow" }
        end
    end


    if user_past_workout_units.where(:exercise_id => exercise.id)
      # They've done this before -- no probationary period.
      # Determine the max rep percent based on their period
      # phase and their max rep percentages
      logger.debug "next_perodize_phase: #{next_perodize_phase}"
      logger.debug "weight_class_for_final_rep: #{Perodization.weight_class_for_final_rep(next_perodize_phase)}"
      max_rep_percent, difficulity = case Perodization.weight_class_for_final_rep(next_perodize_phase)
        when :low then [info[:load].min, "light"]
        when :mean then [(info[:load].min + info[:load].max)/2, "medium"]
        when :high then [info[:load].max, "heavy"]
      end
      all_reps = Perodization.reps(next_perodize_phase)
    else
        # New exercise for them...let's break them in easy
        all_reps = [12, 12, 12]
        max_rep_percent = info[:load].min - 10 # Take 10% off their min
    end

    # Convert the percent of the weight they should lift into an actual number
    logger.debug "difficulity: #{difficulity}"
    logger.debug "max_rep_percent: #{max_rep_percent}"
    logger.debug "muscle group: #{exercise.muscle_group.name.to_sym}"
    
    weight_max = user.evaluations.last.one_rep_max(exercise.muscle_group.name.to_sym, max_rep_percent)
    logger.debug "weight_max: #{weight_max}"
    all_weights = [weight_max-10, weight_max-5, weight_max]
    
    # Setup the final array of reps and weight
    reps_and_weights = []
    3.times do |i|
      reps_and_weights << {:reps => all_reps[i], :weight =>  all_weights[i]}
    end
    
    # Adjust the reps and weights so that they are doable for the exercise
    # For example, you can't bench press 63 pounds.  So what we do instead
    # is calculate the target volume based on the reps and weight we want
    # to do.  Then, we find a combination that is close to, but less than,
    # that volume with a combination of weights and reps such that they are
    # actually doable on this exercise.  For example, now we'll bench 60
    # punds, but we'll do it an additional 2 times to make up for the lower
    # weight.
    target_volume = calc_volume(reps_and_weights)
    reps_and_weights = select_doable_reps_and_weight_for_exercise_with_similar_volume(target_volume, exercise, reps_and_weights)

    # And go!
    return [reps_and_weights, difficulity, target_volume]
  end
  
  def self.select_doable_reps_and_weight_for_exercise_with_similar_volume(target_volume, exercise, reps_and_weights)
    wi = exercise.weight_interval
    min_diff = Float::INFINITY

    logger.debug "Original reps and weights: #{reps_and_weights}"
    logger.debug "Weight Interval for this #{exercise.name} is #{wi}"
    3.times do |i|
      weight = reps_and_weights[i][:weight]
      if weight % wi > 0
        # Round down the weight to the nearest doable weight
        reps_and_weights[i][:weight] =  ((weight-(wi/2))/wi.to_f).round*wi
      end
    end
    logger.debug "New reps and weights: #{reps_and_weights.inspect}"
    logger.debug "Adjusted volume to: #{calc_volume(reps_and_weights)}"     
    
    10.times do |i|
      new_volume = calc_volume(reps_and_weights)  
      diff = new_volume - target_volume
      
      if ((1.0-(new_volume/target_volume.to_f))*100).abs <= 2
        # New volume is within 5% of the original volume, accept this workout
        logger.debug "Breaking, because percentage diff between new volume and only volume is <= 2%"
        break
      end
      
      if calc_volume(reps_and_weights) < target_volume
        # we're doing less work than the original target, so raise the reps
        logger.info "Raising volume"
        reps_and_weights.first[:reps] += 1
      else
        # We're doing more work than the original target, so lower the reps
        logger.info "Lowering volume"
        reps_and_weights.last[:reps] -= 1
      end
      logger.debug "Adjusted reps and weights to: #{reps_and_weights.inspect}"   
      logger.debug "Adjusted volume to: #{calc_volume(reps_and_weights)}"     
      logger.debug "Target volume: #{target_volume}"
    end
    logger.debug "Final reps and weights: #{reps_and_weights.inspect}"        
    logger.debug "Final volume: #{calc_volume(reps_and_weights)}"     
    logger.debug "Target volume: #{target_volume}"
    
    reps_and_weights
  end
  
  
  def self.get_exercises_for_target_group(muscle_group_id, num_from_each_group = 3)
    Exercise.where(:muscle_group_id => muscle_group_id).limit(num_from_each_group)
  end

  # Determines which muscle groups should be worked out
  def self.determine_muscle_groups_to_workout(user)
    muscle_groups = user.muscle_groups
    target_groups = []
    construct_an_abs_workout = false
    
    if muscle_groups.map(&:name).include?("abs")
      # User wants to work the abs.  Since we treat these different from
      # other muscle groups, delete it from this array, and note it. We'll
      # construct a special abs workout later.
      muscle_groups.delete_if { |mg| mg.name == "abs" }
      construct_an_abs_workout = true
    end
    
    if user.workouts.empty?
      # user have no workout history
      target_groups << muscle_groups[0]
      target_groups << muscle_groups[1]
    else
      logger.debug "here: #{muscle_groups.inspect}"
      
      # Don't workout the same muscle groups as last time
      last_primary_group = user.workouts.last.muscle_group_1_id
      last_secondary_group = user.workouts.last.muscle_group_2_id
      logger.debug "Last prim group: #{last_primary_group}"
      last_group_index = muscle_groups.index(MuscleGroup.find(last_primary_group))
      
      if muscle_groups.size == 1
        target_groups = get_next_muscle_group(last_group_index, muscle_groups, 1)
      else
        # We add +1 to the last_group_index here so that we can skip over the
        # previous 2 muscle groups that were used.  That is, since there are
        # >1 muscle groups selected by the user, we automatically selected a
        # primary and secondary group for the previous work.  Therefore, 
        # since last_group_index is the index of the last primary group, go
        # ahead and skip over the secondary group too, which is +1 of the
        # primary group in the muscle groups array.
        last_secondary_group_index = muscle_groups.index(MuscleGroup.find(last_secondary_group))
        target_groups = get_next_muscle_group(last_secondary_group_index, muscle_groups, 2)
      end
    end    
    return [target_groups, construct_an_abs_workout]
  end

  # Iterates over the muscle groups selecting the next ones in line
  def self.get_next_muscle_group(curr_index, muscle_groups, count)
    next_muscle_groups = []
    logger.debug "curr_index: #{curr_index}"
    logger.debug "count: #{count}"
    logger.debug "muscle_groups.size: #{muscle_groups.size}"
    if (curr_index + 1) >= muscle_groups.size
      logger.debug "branch 1"
      next_muscle_groups << muscle_groups[0]
      next_muscle_groups << muscle_groups[1] if count == 2
    elsif (curr_index + 2) >= muscle_groups.size
      logger.debug "branch 2"
      next_muscle_groups << muscle_groups.last
      next_muscle_groups << muscle_groups[0] if count == 2
    else
      logger.debug "branch 3"
      next_muscle_groups << muscle_groups[curr_index+1]
      next_muscle_groups << muscle_groups[curr_index+2] if count == 2
    end
    
    next_muscle_groups
  end  
end
