class RemovePerodizePhaseFromWorkout < ActiveRecord::Migration
  def up
    remove_column :workouts, :perodize_phase
  end
  
  def down
    add_column :workouts, :perodize_phase, :integer
  end
end
