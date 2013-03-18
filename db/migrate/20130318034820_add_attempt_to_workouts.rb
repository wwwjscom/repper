class AddAttemptToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :mg1_phase_attempt_counter, :integer, :default => 1
    add_column :workouts, :mg2_phase_attempt_counter, :integer, :default => 1
  end
end
