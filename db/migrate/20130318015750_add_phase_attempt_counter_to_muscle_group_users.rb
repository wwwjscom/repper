class AddPhaseAttemptCounterToMuscleGroupUsers < ActiveRecord::Migration
  def change
    add_column :muscle_groups_users, :phase_attempt_counter, :integer, :default => 1
  end
end
