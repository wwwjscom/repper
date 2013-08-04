class ChangeUserGoalFormatInUser < ActiveRecord::Migration
  def up
    remove_column :users, :goal
    add_column :users, :goal, :integer
  end

  def down
    remove_column :users, :goal
    add_column :users, :goal, :string
  end
end
