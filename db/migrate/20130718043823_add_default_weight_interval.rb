class AddDefaultWeightInterval < ActiveRecord::Migration
  def up
    change_column :exercises, :weight_interval, :integer, :default => 0.0
  end

  def down
    change_column :exercises, :weight_interval, :integer, :default => nil
  end
end
