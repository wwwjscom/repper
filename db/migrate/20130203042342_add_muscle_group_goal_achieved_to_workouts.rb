class AddMuscleGroupGoalAchievedToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :muscle_group_1_goal_achieved, :integer, :default => 0
    add_column :workouts, :muscle_group_2_goal_achieved, :integer, :default => 0
  end
end
