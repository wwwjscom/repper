class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :chest_weight
      t.integer :chest_reps
      t.integer :shoulder_weight
      t.integer :should_reps
      t.integer :arms_weight
      t.integer :arms_reps
      t.integer :legs_weight
      t.integer :legs_reps
      t.integer :back_weight
      t.integer :back_reps
      t.integer :crunch_reps

      t.timestamps
    end
  end
end
