class Exercise < ActiveRecord::Base
  attr_accessible :weights_required, :machine, :muscle_group_id, :name, :skill_level, :weight_adjustment
  belongs_to :muscle_group

end
