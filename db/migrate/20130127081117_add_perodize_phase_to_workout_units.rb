class AddPerodizePhaseToWorkoutUnits < ActiveRecord::Migration
  def change
    add_column :workout_units, :perodize_phase, :integer
  end
end
