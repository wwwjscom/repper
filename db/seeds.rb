# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:email => "wwwjscom@gmail.com", :password => "temp4now", :password_confirmation => "temp4now")
Evaluation.create(
  :bicep_reps => 20, 
  :bicep_weight => 40, 
  :tricep_reps => 12, 
  :tricep_weight => 30, 
  :back_reps => 20, 
  :back_weight => 80, 
  :lower_back_reps => 20,
  :lower_back_weight => 25, 
  :chest_reps => 15, 
  :chest_weight => 100, 
  :crunch_reps => 60, 
  :legs_reps => 20, 
  :legs_weight => 100, 
  :shoulder_reps => 15, 
  :shoulder_weight => 30, 
  :user_id => User.first.id
)