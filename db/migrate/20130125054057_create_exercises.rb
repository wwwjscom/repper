class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :muscle_group
      t.integer :skill_level
      t.boolean :machine
      t.boolean :gym_required
      t.integer :weight_adjustment

      t.timestamps
    end
  end
end
