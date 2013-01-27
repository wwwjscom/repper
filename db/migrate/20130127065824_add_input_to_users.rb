class AddInputToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age, :integer
    add_column :users, :experience, :integer
    add_column :users, :sex, :string
  end
end
