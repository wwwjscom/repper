class CreateWorkoutUnitAbs < ActiveRecord::Migration
  def up
    create_table :workout_unit_abs do |t|
      t.integer :workout_id
      t.integer :exercise_id
      t.integer :reps
      t.integer :actual_reps
      t.integer :user_id
      
      t.timestamps
    end
  end

  def down
    drop_table :workout_unit_abs
  end
end
