class AdjustWeightForInclinedBenchPress < ActiveRecord::Migration
  def up
    Exercise.find_by_name("incline bench").update_attribute(:weight_adjustment, 0.55)
  end

  def down
    Exercise.find_by_name("incline bench").update_attribute(:weight_adjustment, 1.0)
  end
end
