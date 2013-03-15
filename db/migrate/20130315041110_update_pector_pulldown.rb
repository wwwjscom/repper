class UpdatePectorPulldown < ActiveRecord::Migration
  def up
    mg_id = MuscleGroup.find_by_name("bicep").id
    Exercise.find_by_name("pector pulldown").update_attribute(:muscle_group_id, mg_id)
  end

  def down
    mg_id = MuscleGroup.find_by_name("chest").id
    Exercise.find_by_name("pector pulldown").update_attribute(:muscle_group_id, mg_id)
  end
end
