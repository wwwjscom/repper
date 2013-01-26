class AddActualRepsToWorkoutUnits < ActiveRecord::Migration
  def change
    add_column :workout_units, :actual_reps_1, :integer
    add_column :workout_units, :actual_reps_2, :integer
    add_column :workout_units, :actual_reps_3, :integer
  end
end
