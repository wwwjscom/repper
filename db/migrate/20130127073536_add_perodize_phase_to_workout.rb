class AddPerodizePhaseToWorkout < ActiveRecord::Migration
  def change
    add_column :workouts, :perodize_phase, :integer
  end
end
