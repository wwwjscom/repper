class UpdateProgressionModel < ActiveRecord::Migration
  def up            
    add_column :workout_units, :lower_bound_met_set_1, :boolean, :default => false
    add_column :workout_units, :maxed_out_set_1, :boolean, :default => false

    add_column :workout_units, :lower_bound_met_set_2, :boolean, :default => false
    add_column :workout_units, :maxed_out_set_2, :boolean, :default => false

    add_column :workout_units, :lower_bound_met_set_3, :boolean, :default => false
    add_column :workout_units, :maxed_out_set_3, :boolean, :default => false
    
    add_column :workout_units, :recommendation, :string
    
    add_column :workout_units, :progression_phase, :integer, :default => 1
    add_column :workout_units, :pass_counter, :integer, :default => 0
    add_column :workout_units, :hold_counter, :integer, :default => 0
    
    add_column :workout_units, :min_reps_set_1, :integer
    add_column :workout_units, :min_reps_set_2, :integer
    add_column :workout_units, :min_reps_set_3, :integer
    
    rename_column :workout_units, :actual_reps_1, :actual_reps_set_1
    rename_column :workout_units, :actual_reps_2, :actual_reps_set_2
    rename_column :workout_units, :actual_reps_3, :actual_reps_set_3
    
    add_column :workout_units, :max_reps_set_1, :integer
    add_column :workout_units, :max_reps_set_2, :integer
    add_column :workout_units, :max_reps_set_3, :integer
    
    WorkoutUnit.all.each do |wu|      
      # Copy over rep info to new column so old column can be destroyed
      wu.max_reps_set_1 = wu.rep_1.to_i
      wu.max_reps_set_2 = wu.rep_2.to_i
      wu.max_reps_set_3 = wu.rep_3.to_i
      
      # Now set various statistics about previous workouts
      wu.min_reps_set_1 = wu.max_reps_set_1 - 4
      wu.min_reps_set_2 = wu.max_reps_set_2 - 4
      wu.min_reps_set_3 = wu.max_reps_set_3 - 4
      
      wu.lower_bound_met_set_1 = ((wu.actual_reps_set_1 ||= 0) >= wu.min_reps_set_1)
      wu.lower_bound_met_set_2 = ((wu.actual_reps_set_2 ||= 0) >= wu.min_reps_set_2)
      wu.lower_bound_met_set_3 = ((wu.actual_reps_set_3 ||= 0) >= wu.min_reps_set_3)
      
      wu.maxed_out_set_1 = ((wu.actual_reps_set_1 ||= 0) >= wu.max_reps_set_1)
      wu.maxed_out_set_2 = ((wu.actual_reps_set_2 ||= 0) >= wu.max_reps_set_2)
      wu.maxed_out_set_3 = ((wu.actual_reps_set_3 ||= 0) >= wu.max_reps_set_3)
      
      if wu.maxed_out_set_1 && wu.maxed_out_set_2 && wu.maxed_out_set_3
        wu.recommendation = "pass"
        wu.pass_counter += 1
      elsif wu.lower_bound_met_set_1 && wu.lower_bound_met_set_2 && wu.lower_bound_met_set_3
        wu.recommendation = "hold"
        wu.hold_counter += 1
      else
        wu.recommendation = "fail"
      end
      
      wu.save
    end
    
    remove_column :workout_units, :rep_1
    remove_column :workout_units, :rep_2
    remove_column :workout_units, :rep_3
  end

  def down
    
    add_column :workout_units, :rep_1, :string
    add_column :workout_units, :rep_2, :string
    add_column :workout_units, :rep_3, :string
    
    WorkoutUnit.all.each do |wu|
      wu.rep_1 = wu.max_reps_set_1.to_s
      wu.rep_2 = wu.max_reps_set_2.to_s
      wu.rep_3 = wu.max_reps_set_3.to_s
    end
    
    remove_column :workout_units, :max_reps_set_1
    remove_column :workout_units, :max_reps_set_2
    remove_column :workout_units, :max_reps_set_3
    
    rename_column :workout_units, :actual_reps_set_1, :actual_reps_1
    rename_column :workout_units, :actual_reps_set_2, :actual_reps_2
    rename_column :workout_units, :actual_reps_set_3, :actual_reps_3
    
    remove_column :workout_units, :min_reps_set_1
    remove_column :workout_units, :min_reps_set_2
    remove_column :workout_units, :min_reps_set_3

    remove_column :workout_units, :lower_bound_met_set_1
    remove_column :workout_units, :maxed_out_set_1

    remove_column :workout_units, :lower_bound_met_set_2
    remove_column :workout_units, :maxed_out_set_2

    remove_column :workout_units, :lower_bound_met_set_3
    remove_column :workout_units, :maxed_out_set_3
    
    remove_column :workout_units, :recommendation    
    
    remove_column :workout_units, :progression_phase
    remove_column :workout_units, :pass_counter
    remove_column :workout_units, :hold_counter
  end
end
