class AddDifficulityToWorkoutUnits < ActiveRecord::Migration
  def change
    add_column :workout_units, :diff_1, :string
    add_column :workout_units, :diff_2, :string
    add_column :workout_units, :diff_3, :string
  end
end
