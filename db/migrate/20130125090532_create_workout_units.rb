class CreateWorkoutUnits < ActiveRecord::Migration
  def change
    create_table :workout_units do |t|
      t.integer :workout_id
      t.integer :exercise_id
      t.integer :rep_1
      t.integer :weight_1
      t.integer :rep_2
      t.integer :weight_2
      t.integer :rep_3
      t.integer :weight_3

      t.timestamps
    end
  end
end
