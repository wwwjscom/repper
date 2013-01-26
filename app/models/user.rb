class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :muscle_group_ids, :goal

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :evaluations, :dependent => :destroy
  has_many :workouts, :dependent => :destroy
  has_and_belongs_to_many :muscle_groups
end
