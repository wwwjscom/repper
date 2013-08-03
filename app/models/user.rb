class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :user_muscle_groups, :goal, :sex, :experience, :dob

  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  validates :sex, :inclusion => { :in => %w(Male Female) }
  validates :experience, :exclusion => { :in => [-1], :message => "must be selected" }
  validates :goal, :exclusion => { :in => ["Select One"], :message => "must be selected" }
  
  has_many :evaluations, :dependent => :destroy
  has_many :workouts, :dependent => :destroy
  has_many :workout_units, :dependent => :destroy
  has_many :workout_unit_abs, :dependent => :destroy
  has_many :progression_event_logs, :dependent => :destroy

  has_many :muscle_groups_users
  has_many :muscle_groups, :through => :muscle_groups_users
  
  def user_muscle_groups=(attributes)
    self.muscle_groups = []
    attributes.each do |mg_id, checked|
      next unless checked == "1"
      self.muscle_groups << MuscleGroup.find(mg_id)
    end
  end
end
