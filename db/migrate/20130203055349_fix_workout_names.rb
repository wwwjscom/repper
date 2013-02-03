class FixWorkoutNames < ActiveRecord::Migration
  def up
    e = Exercise.find_by_name("sitting behind head lifts")
    e.update_attribute(:name, "two arm seated dumbbell extension")
    e.update_attribute(:skill_level, 1)

    e = Exercise.find_by_name("shoulder press")
    e.update_attribute(:name, "dumbbell shoulder press")
    e.update_attribute(:skill_level, 1)
    
    e = Exercise.find_by_name("curls")
    e.update_attribute(:name, "dumbbell curls")

    e = Exercise.find_by_name("standing front row")
    e.update_attribute(:name, "standing dumbbell upright row")
    
    e = Exercise.find_by_name("incline bench")
    e.update_attribute(:skill_level, 1)

    e = Exercise.find_by_name("shrugs")
    e.update_attribute(:name, "dumbbell shoulder shrugs")
    e.update_attribute(:skill_level, 1)
  end

  def down
  end
end
