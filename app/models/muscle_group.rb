class MuscleGroup < ActiveRecord::Base
  attr_accessible :name
  
  has_many :exercises
  has_and_belongs_to_many :users
end
