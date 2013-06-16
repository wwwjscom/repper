class CreateProgressionEventLogs < ActiveRecord::Migration
  def change
    create_table :progression_event_logs do |t|
      t.integer :workout_unit_id
      t.string :progression_outcome
      t.integer :new_1RM
      t.integer :user_id
      t.integer :exercise_id

      t.timestamps
    end
  end
end
