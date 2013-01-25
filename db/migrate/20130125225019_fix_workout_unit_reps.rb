class FixWorkoutUnitReps < ActiveRecord::Migration
  def up
    change_column :workout_units, :rep_1, :string
    change_column :workout_units, :rep_2, :string
    change_column :workout_units, :rep_3, :string
  end

  def down
  end
end
