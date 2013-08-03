class RemoveLegsFromMuscleGroups < ActiveRecord::Migration
  def up
    MuscleGroup.find_by_name("legs").destroy
  end

  def down
    MuscleGroup.create(:name => "legs")
  end
end
