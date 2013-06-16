class AddEligibleToWorkoutUnit < ActiveRecord::Migration
  def change
    add_column :workout_units, :eligible_for_evaluation, :boolean, :default => false
  end
end
