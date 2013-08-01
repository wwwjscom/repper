class FixDefaultValueForProgressPhase < ActiveRecord::Migration
  def up
    change_column :workout_units, :progression_phase, :integer, :default => 0
  end

  def down
    change_column :workout_units, :progression_phase, :integer, :default => 1
  end
end
