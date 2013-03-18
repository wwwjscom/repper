class AddPerodizePhaseToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :mg1_perodize_phase, :integer, :default => 1
    add_column :workouts, :mg2_perodize_phase, :integer, :default => 1
  end
end
