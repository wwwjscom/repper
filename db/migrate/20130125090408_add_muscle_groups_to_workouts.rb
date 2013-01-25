class AddMuscleGroupsToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :muscle_group_1_id, :integer
    add_column :workouts, :muscle_group_2_id, :integer
  end
end
