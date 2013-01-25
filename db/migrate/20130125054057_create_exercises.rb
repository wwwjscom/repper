class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :muscle_group
      t.integer :skill_level
      t.boolean :machine
      t.boolean :weights_required
      t.integer :weight_adjustment

      t.timestamps
    end
    
    Exercise.create(
      :name => "row machine",
      :muscle_group => "back",
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "v-bar push down",
      :muscle_group => "tricep",
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "over head pull down",
      :muscle_group => "back",
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "rope push down",
      :muscle_group => "tricep",
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "sitting behind head lifts",
      :muscle_group => "tricep",
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "shoulder press",
      :muscle_group => "shoulder",
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "curls",
      :muscle_group => "bicep",
      :skill_level => 1,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "reverse crunch w/weight",
      :muscle_group => "lower back",
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "pector pulldown",
      :muscle_group => "chest",
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "bench knee arm lifts",
      :muscle_group => "back",
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "gravitor",
      :muscle_group => "bicep",
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "straight bar curl",
      :muscle_group => "bicep",
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "standing front row",
      :muscle_group => "shoulder",
      :skill_level => 1,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "incline bench",
      :muscle_group => "chest",
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "shrugs",
      :muscle_group => "shoulder",
      :skill_level => 2,
      :machine => 0,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "sitting bench machine",
      :muscle_group => "chest",
      :skill_level => 1,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "standing pully straight arm lift",
      :muscle_group => "shoulder",
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "heurclies",
      :muscle_group => "chest",
      :skill_level => 2,
      :machine => 1,
      :weights_required => 1,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "90 deg crunch",
      :muscle_group => "abs",
      :skill_level => 1,
      :machine => 0,
      :weights_required => 0,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "crunch",
      :muscle_group => "abs",
      :skill_level => 1,
      :machine => 0,
      :weights_required => 0,
      :weight_adjustment => -1
    )

    Exercise.create(
      :name => "reverse crunch",
      :muscle_group => "abs",
      :skill_level => 1,
      :machine => 0,
      :weights_required => 0,
      :weight_adjustment => -1
    )
  end
end
