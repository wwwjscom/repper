class WorkoutUnitAb < ActiveRecord::Base
  attr_accessible :exercise_id, :reps, :workout_id, :actual_reps, :user_id
  
  belongs_to :exercise
  belongs_to :workout
  belongs_to :user
  
  # Generate the abs portion of the workout.
  # Parameters
  #   user - The user obj of the current user
  #
  # Returns
  #   A array of hashes, where each hash has an Exercise obj
  #     and an associated number of reps.
  def self.generate_abs_workout(user)
    exercises          = pick_abs_exercises
    exercises_and_reps = pick_abs_reps(exercises, user)
    exercises_and_reps
  end
  
  # Randomly selects _count_ number of abs exercises
  # and returns them in an array of Exercise objects.
  #
  # Parameters
  #   count - number of abs exercises to return
  #
  # Returns
  #   An array of Exercises objects.
  def self.pick_abs_exercises(count = 4)
    chosen_exercises = []
    abs_exercises = MuscleGroup.find_by_name("abs").exercises
    count.times do
      rand_index = rand(abs_exercises.size)
      chosen_exercises << abs_exercises[rand_index]
    end    
    chosen_exercises
  end
  
  # Decides how many reps of each abs exercises should be
  # done for the user.  This should be based on their previous
  # ability to complete the given number of abs reps.
  #
  # Parameters
  #   exercises - An array of abs Exercises objects
  #   user - The user who owns the workout
  #
  # Returns
  #   A array of hashes, where each hash has an Exercise obj
  #     and an associated number of reps.
  def self.pick_abs_reps(exercises, user)
    exercises_and_reps = []
    # TODO: Add the logic here to intelligently generate abs reps
    exercises.each do |e|
      exercises_and_reps << { 
        :exercise => e,
        :reps     => 20
      }
    end
    exercises_and_reps
  end
  
  
end
