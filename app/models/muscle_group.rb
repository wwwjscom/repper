class MuscleGroup < ActiveRecord::Base
  attr_accessible :name
  
  has_many :exercises
end
