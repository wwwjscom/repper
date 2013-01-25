class CreateMuscleGroupsUsersJoinTable < ActiveRecord::Migration
  def up
    create_table :muscle_groups_users do |t|
      t.integer :muscle_group_id
      t.integer :user_id
    end
  end

  def down
    drop_table :muscle_groups_users
  end
end
