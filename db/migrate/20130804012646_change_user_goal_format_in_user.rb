class ChangeUserGoalFormatInUser < ActiveRecord::Migration
  def up
    change_column :users, :goal, :integer
  end

  def down
    change_column :users, :goal, :string
  end
end
