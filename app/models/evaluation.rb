class Evaluation < ActiveRecord::Base
  attr_accessible :arms_reps, :arms_weight, :back_reps, :back_weight, :chest_reps, :chest_weight, :crunch_reps, :legs_reps, :legs_weight, :should_reps, :shoulder_weight, :user_id
end
