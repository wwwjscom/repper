class FixDefaultWeightAdjustments < ActiveRecord::Migration
  def up
    change_column :exercises, :weight_adjustment, :float, :default => 1.0
    Exercise.reset_column_information
    Exercise.all.each { |e| e.update_attribute(:weight_adjustment, 1.0)}
  end

  def down
    change_column :exercises, :weight_adjustment, :integer, :default => -1
    Exercise.reset_column_information
    Exercise.all.each { |e| e.update_attribute(:weight_adjustment, -1)}
  end
end