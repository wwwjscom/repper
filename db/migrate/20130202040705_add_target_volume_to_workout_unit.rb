class AddTargetVolumeToWorkoutUnit < ActiveRecord::Migration
  def change
    add_column :workout_units, :target_volume, :integer
  end
end
