class Evaluation < ActiveRecord::Base
  attr_accessible :bicep_reps, :bicep_weight, :tricep_reps, :tricep_weight, :back_reps, :back_weight, :lower_back_reps, :lower_back_weight, :chest_reps, :chest_weight, :crunch_reps, :legs_reps, :legs_weight, :shoulder_reps, :shoulder_weight, :user_id
  
  belongs_to :user
  
  def light_weight(workout)
    (get_reps_and_weight_for(workout) || 0) *0.7
  end
  
  def med_weight(workout)
    (get_reps_and_weight_for(workout) || 0) *0.75
  end
  
  def heavy_weight(workout)
    (get_reps_and_weight_for(workout) || 0) *0.80
  end
  
  def one_rep_max(reps, weight)
    (((reps.to_f/30)+1)*weight.to_f)
  end
  
  def get_reps_and_weight_for(workout)
    case workout
    when :chest then one_rep_max(chest_reps, chest_weight)
    when :bicep then one_rep_max(bicep_reps, bicep_weight)
    when :tricep then one_rep_max(tricep_reps, tricep_weight)
    when :crunch then one_rep_max(crunch_reps, 10) # FIXME: How do we calc this?
    when :shoulder then one_rep_max(shoulder_reps, shoulder_weight)
    when :back then one_rep_max(back_reps, back_weight)
    when :lower_back then one_rep_max(lower_back_reps, lower_back_weight)
    end
  end
end
