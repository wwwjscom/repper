class FixExerciseWorkoutId < ActiveRecord::Migration
  def up
    remove_column :exercises, :muscle_group
    add_column :exercises, :muscle_group_id, :integer
  end
  
  def down
    add_column :exercises, :muscle_group, :string
    remove_column :exercises, :muscle_group_id
  end
end
