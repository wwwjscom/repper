class MuscleGroupsUser < ActiveRecord::Base
  attr_accessible :perodize_phase
  
  belongs_to :user
  belongs_to :muscle_group
end