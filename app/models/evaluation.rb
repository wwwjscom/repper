class Evaluation < ActiveRecord::Base
  attr_accessible :bicep_reps, :bicep_weight, :tricep_reps, :tricep_weight, :back_reps, :back_weight, :lower_back_reps, :lower_back_weight, :chest_reps, :chest_weight, :crunch_reps, :legs_reps, :legs_weight, :shoulder_reps, :shoulder_weight, :user_id
  
  belongs_to :user

  def _60_weight(workout)
    (one_rep_max(workout) || 0) *0.60
  end
  
  def _65_weight(workout)
    (one_rep_max(workout) || 0) *0.65
  end  
  
  def _70_weight(workout)
    (one_rep_max(workout) || 0) *0.7
  end
  
  def _75_weight(workout)
    (one_rep_max(workout) || 0) *0.75
  end
  
  def _80_weight(workout)
    (one_rep_max(workout) || 0) *0.80
  end
    
  def calc_one_rep_max(reps, weight)
    (((reps.to_f/30)+1)*weight.to_f)
  end
  
  def one_rep_max(muscle_group, rep_percent = 100.0)
    case muscle_group
    when :chest then calc_one_rep_max(chest_reps, chest_weight) * rep_percent
    when :bicep then calc_one_rep_max(bicep_reps, bicep_weight) * rep_percent
    when :tricep then calc_one_rep_max(tricep_reps, tricep_weight)* rep_percent
    when :abs then calc_one_rep_max(crunch_reps, 10) * rep_percent # FIXME: How do we calc this?
    when :shoulder then calc_one_rep_max(shoulder_reps, shoulder_weight) * rep_percent
    when :back then calc_one_rep_max(back_reps, back_weight) * rep_percent
    when :lower_back then calc_one_rep_max(lower_back_reps, lower_back_weight) * rep_percent
    end
  end
end
