class RemovingOldColumns < ActiveRecord::Migration
  def up
    remove_column :workouts, :muscle_group_1_goal_achieved
    remove_column :workouts, :muscle_group_2_goal_achieved    
    remove_column :workouts, :mg1_perodize_phase    
    remove_column :workouts, :mg2_perodize_phase
  end

  def down
    # Too lazy to write it the other way.  Not like I use these anyways.
  end
end
