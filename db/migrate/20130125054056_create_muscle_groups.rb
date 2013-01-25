class CreateMuscleGroups < ActiveRecord::Migration
  def change
    create_table :muscle_groups do |t|
      t.string :name

      t.timestamps
    end
    
    MuscleGroup.create(:name => "back")
    MuscleGroup.create(:name => "chest")
    MuscleGroup.create(:name => "shoulder")
    MuscleGroup.create(:name => "bicep")
    MuscleGroup.create(:name => "tricep")
    MuscleGroup.create(:name => "legs")
    MuscleGroup.create(:name => "lower back")
    MuscleGroup.create(:name => "abs")

  end
end
