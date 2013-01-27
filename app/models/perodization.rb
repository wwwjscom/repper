class Perodization < ActiveRecord::Base
  attr_accessible :muscle_group_id, :perodization_phase, :user_id
  
  belongs_to :user
  belongs_to :muscle_group
  
  MAX_PHASE = 14
  
  def self.reps(phase)
    case phase
      when 1..2 then [12,12,12]
      when 3..4 then [12,12,11]
      when 5..6 then [12,12,7]
      when 7..8 then [12,12,8]
      when 9..14 then [12,12,12]
    end
  end
  
  def self.weight_class_for_final_rep(phase)
    case phase
      when 1..2 then :low
      when 3..4 then :mean
      when 5..6 then :high
      when 7..8 then :high
      when 9..10 then :mean
      when 11..14 then :high
    end
  end
end
