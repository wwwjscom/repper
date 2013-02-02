class AddPerodizePhaseToMuscleGroupsUsers < ActiveRecord::Migration
  def change
    add_column :muscle_groups_users, :perodize_phase, :integer
  end
end
