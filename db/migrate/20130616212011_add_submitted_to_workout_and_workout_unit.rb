class AddSubmittedToWorkoutAndWorkoutUnit < ActiveRecord::Migration
  def change
    add_column :workout_units, :submitted, :boolean, :default => false
    add_column :workouts, :submitted, :boolean, :default => false
  end
end
