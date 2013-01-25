class Exercise < ActiveRecord::Base
  attr_accessible :weights_required, :machine, :muscle_group, :name, :skill_level, :weight_adjustment
end
