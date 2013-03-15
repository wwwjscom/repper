class RemoveGravitonExercise < ActiveRecord::Migration
  def up
    Exercise.delete(Exercise.find_by_name("gravitor"))
  end

  def down
  end
end
