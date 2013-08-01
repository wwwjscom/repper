class FixInclinedBenchPressIntervals < ActiveRecord::Migration
  def up
    Exercise.find_by_name("incline bench").update_attribute(:weight_interval, 10)
  end

  def down
    Exercise.find_by_name("incline bench").update_attribute(:weight_interval, 5)
  end
end
