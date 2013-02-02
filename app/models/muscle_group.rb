class MuscleGroup < ActiveRecord::Base
  attr_accessible :name
  
  has_many :exercises
  has_many :muscle_groups_users
  has_many :users, :through => :muscle_groups_users

end
