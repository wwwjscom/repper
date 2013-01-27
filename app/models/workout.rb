class Workout < ActiveRecord::Base
  attr_accessible :user_id, :muscle_group_1_id, :muscle_group_2_id, :workout_units_attributes, :perodize_phase
  has_many :workout_units, :dependent => :destroy
  accepts_nested_attributes_for :workout_units
  belongs_to :user
  
  def workout_units
    WorkoutUnit.where(:workout_id => self.id).order("id DESC")
  end
  
  def self.generate(user)
    # First, we need to know what areas the user is targeting
    target_groups = determine_muscle_groups_to_workout(user)
    logger.debug "tg: #{target_groups.inspect}"
    
    # Next we need to get the exercises for that area, and 
    # the users expereince level
    
    # Make sure we never select an exercise that's too hard
    # or too easy for the user
    skill_level_range = case user.experience
                          when 0 then 1
                          when 1 then 1
                          when 2 then 1..2
                          when 3 then 2..3          
                        end             
    exercises = get_exercises_for_target_groups(target_groups, skill_level_range)
    logger.debug "tg: #{target_groups.inspect}"
    
    
    # Next we determine the weight, reps, sets, rest and velocity.  
    # This depends on the users exp, goal, exercise, 
    last_perodize_phase = (user.workouts.empty?) ? 1 : user.workouts.last.perodize_phase
    
    if last_perodize_phase > Perodization::MAX_PHASE
      # FIXME: This user needs to graduate to a large weight
      # since they finished a perodization cycle.  Add that logic!!!
      # For now, just set them back to phase 1 with no weight increase
      last_perodize_phase = 1
    end
    
    perodize_workout = []
    exercises.each do |e|
      reps_and_weight, difficulity = perodize_exercise_info(e, user, last_perodize_phase) 
      perodize_workout << { :exercise => e, 
                            :reps_and_weight => reps_and_weight,
                            :difficulity => difficulity
                          }
    end    
    
#    reps_and_weight = {target_groups[0] => [], target_groups[1] => []}
#
#    logger.debug "tg: #{target_groups.inspect}"
#    reps_and_weight[target_groups[0]] = get_reps_and_weight(user, target_groups[0])
#    reps_and_weight[target_groups[1]] = get_reps_and_weight(user, target_groups[1])


    # Now create the workout    
    w = Workout.create(
      :user_id => user.id, 
      :muscle_group_1_id => target_groups[0].id, 
      :muscle_group_2_id => target_groups[1].id,
      :perodize_phase => last_perodize_phase + 1)
    perodize_workout.each do |pw|
      logger.debug "T: #{pw[:exercise].inspect}"
      WorkoutUnit.create(
      :workout_id => w.id, 
      :perodize_phase => last_perodize_phase + 1,
      :exercise_id => pw[:exercise].id, 
      :rep_1 => pw[:reps_and_weight][0][:reps],
      :weight_1 => pw[:reps_and_weight][0][:weight],
      :diff_1 => pw[:difficulity],
      :rep_2 => pw[:reps_and_weight][1][:reps],
      :weight_2 => pw[:reps_and_weight][1][:weight],
      :diff_2 => pw[:difficulity],
      :rep_3 => pw[:reps_and_weight][2][:reps],
      :weight_3 => pw[:reps_and_weight][2][:weight],
      :diff_3 => pw[:difficulity]
      )
    end
    return w
  end
  
  private
  
  def self.perodize_exercise_info(exercise, user, last_perodize_phase)

    user_experience = user.experience
    user_past_workout_units = user.workout_units
    user_goal = user.goal
    
    info = {}
    case user_experience
      when 0 then
        case user_goal.downcase
          when "muscle gain" then info = { :reps => 8..12, :load => 0.50..0.60, :sets => 1..3, :rest => 2..3, :velocity => "slow" }
          when "strength gain" then info = { :reps => 8..12, :load => 0.50..0.60, :sets => 1..3, :rest => 2..3, :velocity => "slow" }
        end
      when 1 then
        case user_goal.downcase
          when "muscle gain" then info = { :reps => 8..12, :load => 0.65..0.75, :sets => 1..3, :rest => 1..2, :velocity => "slow and moderate" }
          when "strength gain" then info = { :reps => 8..12, :load => 0.60..0.70, :sets => 1..3, :rest => 2..3, :velocity => "slow" }
        end
      when 2 then
        case user_goal.downcase
          when "muscle gain" then info = { :reps => 8..12, :load => 0.70..0.85, :sets => 1..3, :rest => 2..3, :velocity => "slow and moderate" }
          when "strength gain" then info = { :reps => 1..12, :load => 0.70..0.85, :sets => 1..3, :rest => 2..3, :velocity => "slow and moderate" }
        end
      when 3 then
        case user_goal.downcase
          when "muscle gain" then info = { :reps => 8..12, :load => 0.70..0.100, :sets => 3..6, :rest => 2..3, :velocity => "all varying" }
          when "strength gain" then info = { :reps => 8..12, :load => 0.70..0.100, :sets => 3..6, :rest => 2..3, :velocity => "slow" }
        end
    end

    if user_past_workout_units.where(:exercise_id => exercise.id)
      # They've done this before -- no probationary period.
      # Determine the max rep percent based on their period
      # phase and their max rep percentages
      logger.debug "last_perodize_phase: #{last_perodize_phase}"
      logger.debug "weight_class_for_final_rep: #{Perodization.weight_class_for_final_rep(last_perodize_phase)}"
      max_rep_percent, difficulity = case Perodization.weight_class_for_final_rep(last_perodize_phase)
        when :low then [info[:load].min, "light"]
        when :mean then [(info[:load].min + info[:load].max)/2, "medium"]
        when :high then [info[:load].max, "heavy"]
      end
      all_reps = Perodization.reps(last_perodize_phase)
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

    # And go!
    return [reps_and_weights, difficulity]
  end
  
  def self.get_reps_and_weight(user, muscle_group)
    logger.debug "mg: #{muscle_group}"
    
    case user.goal.downcase
    when "weight loss" then
      [
        {:weight => user.evaluations.last._60_weight(muscle_group.name.to_sym), :reps => "15-20", :difficulity => "easy"}, 
        {:weight => user.evaluations.last._60_weight(muscle_group.name.to_sym), :reps => "15-20", :difficulity => "easy"}, 
        {:weight => user.evaluations.last._60_weight(muscle_group.name.to_sym), :reps => "15-20", :difficulity => "easy"}
      ]
    when "muscle tone" then
      [
        {:weight => user.evaluations.last._65_weight(muscle_group.name.to_sym), :reps => "15-20", :difficulity => "easy"}, 
        {:weight => user.evaluations.last._65_weight(muscle_group.name.to_sym), :reps => "15-20", :difficulity => "easy"}, 
        {:weight => user.evaluations.last._70_weight(muscle_group.name.to_sym), :reps => "10-15", :difficulity => "medium"}
      ]
    when "muscle gain" then
      [
        {:weight => user.evaluations.last._65_weight(muscle_group.name.to_sym), :reps => "15-20", :difficulity => "easy"}, 
        {:weight => user.evaluations.last._70_weight(muscle_group.name.to_sym), :reps => "10-15", :difficulity => "medium"}, 
        {:weight => user.evaluations.last._75_weight(muscle_group.name.to_sym), :reps => "8-12", :difficulity => "hard"}
      ]
    end
  end

  def self.get_exercises_for_target_groups(target_groups, skill_level_range, num_from_each_group = 3)
    exercises = []
    target_groups.each do |muscle_group_id|
      exercises << Exercise.where(:muscle_group_id => muscle_group_id).where(:skill_level => skill_level_range).limit(num_from_each_group)
    end
    exercises.flatten
  end

  # Determines which muscle groups should be worked out
  def self.determine_muscle_groups_to_workout(user)
    muscle_groups = user.muscle_groups
    target_groups = []
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
    return target_groups
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
