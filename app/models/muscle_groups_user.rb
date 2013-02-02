class MuscleGroupsUser < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :muscle_group
end