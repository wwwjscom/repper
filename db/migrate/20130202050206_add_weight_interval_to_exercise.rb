class AddWeightIntervalToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :weight_interval, :integer
  end
end
