class Workout < ActiveRecord::Base
  attr_accessible :user_id, :muscle_group_1_id, :muscle_group_2_id, :workout_units_attributes, :workout_unit_abs_attributes, :mg1_phase_attempt_counter, :mg2_phase_attempt_counter
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
    # This depends on the users goal, exercise, 
    workout_units = []
    target_groups.each do |tg|
      tg[:exercises].each { |e| workout_units << create_workout_unit(e, user) }
    end
    
    # Now create the workout    
    w = Workout.create(
      :user_id           => user.id, 
      :muscle_group_1_id => target_groups[0][:muscle_group].id, 
      :muscle_group_2_id => target_groups[1][:muscle_group].id,
      # TODO: Bug 12 - Rename the 'phase_attempt_counter' to 'volume_attempt_counter'
      :mg1_phase_attempt_counter => user.muscle_groups_users.find_by_muscle_group_id(target_groups[0][:muscle_group].id).phase_attempt_counter,
      :mg2_phase_attempt_counter => user.muscle_groups_users.find_by_muscle_group_id(target_groups[1][:muscle_group].id).phase_attempt_counter
    )

    # Finalize the workout units within the workout
    workout_units.each do |wu|
      wu.workout_id = w.id
      wu.save
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
  
  private
  
  def self.calc_volume(wu)
    volume = 0
    volume += (wu.max_reps_set_1 || 0) * (wu.weight_1 || 0)
    volume += (wu.max_reps_set_2 || 0) * (wu.weight_2 || 0)
    volume += (wu.max_reps_set_3 || 0) * (wu.weight_3 || 0)
    volume
  end
  
  def self.create_workout_unit(exercise, user)

    wu = WorkoutUnit.new
    wu.exercise_id = exercise.id
    wu.user_id = user.id

    user_experience = user.experience
    user_past_workout_units = user.workout_units
    user_goal = user.goal
    
    info = {}
    # TODO: When removing the period, I made this defalt to just use the max load
    #  all the time.  This should probably be updated in the future. Bug 19
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

    wu.diff_1  = "heavy"
    wu.diff_2  = "heavy"
    wu.diff_3  = "heavy"

    if user_past_workout_units.where(:exercise_id => exercise.id)
      # They've done this before -- no probationary period.
      wu.set_weights
    else
        # New exercise for them...let's break them in easy
        max_rep_percent = info[:load].min - 10 # Take 10% off their min
        
      # Since they haven't done this workout before, use their 1RM to determine
      # how much weight they should be lifting.
        weight_max  = user.evaluations.last.one_rep_max(exercise.muscle_group.name.to_sym, max_rep_percent)
        wu.weight_1 = weight_max-10
        wu.weight_2 = weight_max-5
        wu.weight_3 = weight_max
    end
    
    # Setup the reps 
    wu.min_reps_set_1 = info[:reps].min
    wu.max_reps_set_1 = info[:reps].max
    wu.min_reps_set_2 = info[:reps].min
    wu.max_reps_set_2 = info[:reps].max
    wu.min_reps_set_3 = info[:reps].min
    wu.max_reps_set_3 = info[:reps].max    

    wu.target_volume = calc_volume(wu)

    return wu
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
