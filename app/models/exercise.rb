class Exercise < ActiveRecord::Base
  attr_accessible :gym_required, :machine, :muscle_group, :name, :skill_level, :weight_adjustment
end
