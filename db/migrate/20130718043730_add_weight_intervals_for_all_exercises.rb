class AddWeightIntervalsForAllExercises < ActiveRecord::Migration
  def up
    Exercise.find_by_name("row machine").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("v-bar push down").update_attribute(:weight_interval, 5)
    Exercise.find_by_name("over head pull down").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("rope push down").update_attribute(:weight_interval, 5)
    Exercise.find_by_name("two arm seated dumbbell extension").update_attribute(:weight_interval, 5)
    Exercise.find_by_name("dumbbell shoulder press").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("dumbbell curls").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("reverse crunch w/weight").update_attribute(:weight_interval, 5)
    Exercise.find_by_name("pector pulldown").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("bench knee arm lifts").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("straight bar curl").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("standing dumbbell upright row").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("dumbbell shoulder shrugs").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("sitting bench machine").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("standing pully straight arm lift").update_attribute(:weight_interval, 10)
    Exercise.find_by_name("heurclies").update_attribute(:weight_interval, 10)
  end

  def down
    Exercise.find_by_name("row machine").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("v-bar push down").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("over head pull down").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("rope push down").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("two arm seated dumbbell extension").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("dumbbell shoulder press").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("dumbbell curls").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("reverse crunch w/weight").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("pector pulldown").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("bench knee arm lifts").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("straight bar curl").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("standing dumbbell upright row").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("dumbbell shoulder shrugs").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("sitting bench machine").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("standing pully straight arm lift").update_attribute(:weight_interval, nil)
    Exercise.find_by_name("heurclies").update_attribute(:weight_interval, nil)
  end
end
