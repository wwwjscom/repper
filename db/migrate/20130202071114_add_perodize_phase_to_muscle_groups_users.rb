class AddPerodizePhaseToMuscleGroupsUsers < ActiveRecord::Migration
  def change
    add_column :muscle_groups_users, :perodize_phase, :integer, :default => 1
  end
end
