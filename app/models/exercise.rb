class Exercise < ActiveRecord::Base
  attr_accessible :weights_required, :machine, :muscle_group_id, :name, :skill_level, :weight_adjustment, :muscle_group, :weight_interval
  belongs_to :muscle_group

  def self.weight_interval(exercise_id)
    self.find(exercise_id).weight_interval
  end
  
end
