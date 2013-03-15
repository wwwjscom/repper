class RemoveGravitonExercise < ActiveRecord::Migration
  def up
    id = Exercise.find_by_name("gravitor").id
    Exercise.delete(id)
    WorkoutUnit.delete_all(:exercise_id => id)
  end

  def down
  end
end
