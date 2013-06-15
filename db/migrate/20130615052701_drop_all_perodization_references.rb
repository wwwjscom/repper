class DropAllPerodizationReferences < ActiveRecord::Migration
  def up
    remove_column :workouts, :perodize_phase
    remove_column :workout_units, :perodize_phase
    remove_column :muscle_groups_users, :perodize_phase
  end

  def down
    add_column :workouts, :perodize_phase, :integer
    add_column :workout_units, :perodize_phase, :integer
    add_column :muscle_groups_users, :perodize_phase, :integer, :default => 1
  end
end
