class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :user_id
      t.integer :chest_weight
      t.integer :chest_reps
      t.integer :shoulder_weight
      t.integer :should_reps
      t.integer :bicep_weight
      t.integer :bicep_reps
      t.integer :tricep_weight
      t.integer :tricep_reps
      t.integer :legs_weight
      t.integer :legs_reps
      t.integer :back_weight
      t.integer :back_reps
      t.integer :lower_back_weight
      t.integer :lower_back_reps
      t.integer :crunch_reps

      t.timestamps
    end
  end
end
