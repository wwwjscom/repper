class RemoveSkillLevelFromExercises < ActiveRecord::Migration
  def up
    remove_column :exercises, :skill_level
  end

  def down
    add_column :exercises, :skill_level, :integer
    Exercise.find_by_name("row machine").update_attribute(:skill_level, 1)
    Exercise.find_by_name("v-bar push down").update_attribute(:skill_level, 2)
    Exercise.find_by_name("over head pull down").update_attribute(:skill_level, 1)
    Exercise.find_by_name("rope push down").update_attribute(:skill_level, 2)
    Exercise.find_by_name("sitting behind head lifts").update_attribute(:skill_level, 2)
    Exercise.find_by_name("shoulder press").update_attribute(:skill_level, 2)
    Exercise.find_by_name("curls").update_attribute(:skill_level, 1)
    Exercise.find_by_name("reverse crunch w/weight").update_attribute(:skill_level, 2)
    Exercise.find_by_name("pector pulldown").update_attribute(:skill_level, 1)
    Exercise.find_by_name("bench knee arm lifts").update_attribute(:skill_level, 2)
    Exercise.find_by_name("straight bar curl").update_attribute(:skill_level, 2)
    Exercise.find_by_name("standing front row").update_attribute(:skill_level, 1)
    Exercise.find_by_name("incline bench").update_attribute(:skill_level, 2)
    Exercise.find_by_name("shrugs").update_attribute(:skill_level, 2)
    Exercise.find_by_name("sitting bench machine").update_attribute(:skill_level, 1)
    Exercise.find_by_name("standing pully straight arm lift").update_attribute(:skill_level, 2)
    Exercise.find_by_name("heurclies").update_attribute(:skill_level, 2)
    Exercise.find_by_name("90 deg crunch").update_attribute(:skill_level, 1)
    Exercise.find_by_name("crunch").update_attribute(:skill_level, 1)
    Exercise.find_by_name("reverse crunch").update_attribute(:skill_level, 1)
    Exercise.find_by_name("").update_attribute(:skill_level, 1)
    Exercise.find_by_name("").update_attribute(:skill_level, 1)
    Exercise.find_by_name("").update_attribute(:skill_level, 1)
  end
end