class Workout < ActiveRecord::Base
  attr_accessible :user_id, :muscle_group_1_id, :muscle_group_2_id
  has_many :workout_units
  belongs_to :user
  
  def self.generate(user)
    target_groups = determine_muscle_groups_to_workout(user)
    logger.debug "tg: #{target_groups.inspect}"
    
    exercises = get_exercises_for_target_groups(target_groups)
    logger.debug "tg: #{target_groups.inspect}"
    
    reps_and_weight = {target_groups[0] => [], target_groups[1] => []}

    logger.debug "tg: #{target_groups.inspect}"
    reps_and_weight[target_groups[0]] = get_reps_and_weight(user, target_groups[0])
    reps_and_weight[target_groups[1]] = get_reps_and_weight(user, target_groups[1])
    
    w = Workout.create(:user_id => user.id, :muscle_group_1_id => target_groups[0].id, :muscle_group_2_id => target_groups[1].id)
    exercises.each do |e|
      logger.debug "T: #{e.inspect}"
      WorkoutUnit.create(
      :workout_id => w.id, 
      :exercise_id => e.id, 
      :rep_1 => reps_and_weight[e.muscle_group][0][:reps],
      :weight_1 => reps_and_weight[e.muscle_group][0][:weight],
      :diff_1 => reps_and_weight[e.muscle_group][0][:difficulity],
      :rep_2 => reps_and_weight[e.muscle_group][1][:reps],
      :weight_2 => reps_and_weight[e.muscle_group][1][:weight],
      :diff_2 => reps_and_weight[e.muscle_group][1][:difficulity],
      :rep_3 => reps_and_weight[e.muscle_group][2][:reps],
      :weight_3 => reps_and_weight[e.muscle_group][2][:weight],
      :diff_3 => reps_and_weight[e.muscle_group][2][:difficulity]
      )
    end
    return w
  end
  
  private
  
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

  def self.get_exercises_for_target_groups(target_groups, num_from_each_group = 3)
    exercises = []
    target_groups.each do |muscle_group_id|
      exercises << Exercise.where(:muscle_group_id => muscle_group_id).limit(num_from_each_group)
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
      last_group_index = muscle_groups.index(MuscleGroup.find(last_primary_group))
      
      target_groups << get_next_muscle_group(last_group_index, muscle_groups)
      if muscle_groups.size > 1
        target_groups << get_next_muscle_group(last_group_index, muscle_groups)
      end
    end    
    return target_groups
  end

  # Iterates over the muscle groups selecting the next ones in line
  def self.get_next_muscle_group(curr_index, muscle_groups)
    if (curr_index + 1) > muscle_groups.size
      return muscle_groups[0]
    else
      return muscle_groups[curr_index + 1]
    end
    
  end
end
