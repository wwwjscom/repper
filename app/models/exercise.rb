class Exercise < ActiveRecord::Base
  attr_accessible :weights_required, :machine, :muscle_group_id, :name, :skill_level, :weight_adjustment, :muscle_group, :weight_interval
  belongs_to :muscle_group
  has_many :progression_event_logs, :dependent => :destroy

  def self.weight_interval(exercise_id)
    self.find(exercise_id).weight_interval
  end

  # Takes an exercise id and some number, and rounds that number up to the
  # nearest number that can be lifted for a particular exercise.
  #
  # @param exercise_id [Integer]
  # @param weight_to_round [Float] The number to be rounded
  # @return [Integer] The doable weight
  def self.round_up_to_doable_weight(exercise_id, weight_to_round)
    ((self.where(:id => exercise_id).first.weight_interval - weight_to_round % 10) + weight_to_round)
  end

  # Calculates a new 1RM using the given workout units.  This
  # is used for the progression event logs to calculate and
  # store the users recent efforts.
  #
  # @param recent_workout_units [Array<WorkoutUnit>] Typically the 3 most
  #  recent workout units for an exercise
  # @return [Integer] calculated 1RM from the given workout unts.
  def self.new_1RM(recent_workout_units)
    one_rep_maxs = []
    recent_workout_units.each do |wu|
      one_rep_maxs << (((wu.actual_reps_set_1.to_f/30.0)+1.0) * wu.weight_1)
      one_rep_maxs << (((wu.actual_reps_set_2.to_f/30.0)+1.0) * wu.weight_2)
      one_rep_maxs << (((wu.actual_reps_set_3.to_f/30.0)+1.0) * wu.weight_3)
    end
    
    # Get the average, and let that be our new 1RM.
    one_rep_maxs.inject(:+).to_f / one_rep_maxs.size
  end
end
