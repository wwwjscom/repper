class AddExercises < ActiveRecord::Migration
  def up
    
    Exercise.delete_all
    
    Exercise.create(
      :name => "row machine",
      :muscle_group_id => MuscleGroup.find_by_name("back").id,
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "v-bar push down",
      :muscle_group_id => MuscleGroup.find_by_name("tricep").id,
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "over head pull down",
      :muscle_group_id => MuscleGroup.find_by_name("back").id,
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "rope push down",
      :muscle_group_id => MuscleGroup.find_by_name("tricep").id,
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "sitting behind head lifts",
      :muscle_group_id => MuscleGroup.find_by_name("tricep").id,
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "shoulder press",
      :muscle_group_id => MuscleGroup.find_by_name("shoulder").id,
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "curls",
      :muscle_group_id => MuscleGroup.find_by_name("bicep").id,
      :skill_level => 1,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "reverse crunch w/weight",
      :muscle_group_id => MuscleGroup.find_by_name("lower back").id,
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "pector pulldown",
      :muscle_group_id => MuscleGroup.find_by_name("chest").id,
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "bench knee arm lifts",
      :muscle_group_id => MuscleGroup.find_by_name("back").id,
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "gravitor",
      :muscle_group_id => MuscleGroup.find_by_name("bicep").id,
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "straight bar curl",
      :muscle_group_id => MuscleGroup.find_by_name("bicep").id,
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "standing front row",
      :muscle_group_id => MuscleGroup.find_by_name("shoulder").id,
      :skill_level => 1,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "incline bench",
      :muscle_group_id => MuscleGroup.find_by_name("chest").id,
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "shrugs",
      :muscle_group_id => MuscleGroup.find_by_name("shoulder").id,
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "sitting bench machine",
      :muscle_group_id => MuscleGroup.find_by_name("chest").id,
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "standing pully straight arm lift",
      :muscle_group_id => MuscleGroup.find_by_name("shoulder").id,
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "heurclies",
      :muscle_group_id => MuscleGroup.find_by_name("chest").id,
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "90 deg crunch",
      :muscle_group_id => MuscleGroup.find_by_name("abs").id,
      :skill_level => 1,
      :machine => 0,
      :weights_required => 0,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "crunch",
      :muscle_group_id => MuscleGroup.find_by_name("abs").id,
      :skill_level => 1,
      :machine => 0,
      :weights_required => 0,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "reverse crunch",
      :muscle_group_id => MuscleGroup.find_by_name("abs").id,
      :skill_level => 1,
      :machine => 0,
      :weights_required => 0,
      :weight_adjustment => -1
    )
    
    
  end

  def down
  end
end
