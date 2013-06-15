# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130615052701) do

  create_table "evaluations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "chest_weight"
    t.integer  "chest_reps"
    t.integer  "shoulder_weight"
    t.integer  "shoulder_reps"
    t.integer  "bicep_weight"
    t.integer  "bicep_reps"
    t.integer  "tricep_weight"
    t.integer  "tricep_reps"
    t.integer  "legs_weight"
    t.integer  "legs_reps"
    t.integer  "back_weight"
    t.integer  "back_reps"
    t.integer  "lower_back_weight"
    t.integer  "lower_back_reps"
    t.integer  "crunch_reps"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "exercises", :force => true do |t|
    t.string   "name"
    t.boolean  "machine"
    t.boolean  "weights_required"
    t.integer  "weight_adjustment"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "muscle_group_id"
    t.integer  "weight_interval"
  end

  create_table "muscle_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "muscle_groups_users", :force => true do |t|
    t.integer "muscle_group_id"
    t.integer "user_id"
    t.integer "phase_attempt_counter", :default => 1
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "goal"
    t.integer  "age"
    t.integer  "experience"
    t.string   "sex"
  end

  add_index "users", ["last_logout_at", "last_activity_at"], :name => "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"

  create_table "workout_unit_abs", :force => true do |t|
    t.integer  "workout_id"
    t.integer  "exercise_id"
    t.integer  "reps"
    t.integer  "actual_reps"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "workout_units", :force => true do |t|
    t.integer  "workout_id"
    t.integer  "exercise_id"
    t.string   "rep_1"
    t.integer  "weight_1"
    t.string   "rep_2"
    t.integer  "weight_2"
    t.string   "rep_3"
    t.integer  "weight_3"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "diff_1"
    t.string   "diff_2"
    t.string   "diff_3"
    t.integer  "actual_reps_1"
    t.integer  "actual_reps_2"
    t.integer  "actual_reps_3"
    t.integer  "user_id"
    t.integer  "target_volume"
  end

  create_table "workouts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "muscle_group_1_id"
    t.integer  "muscle_group_2_id"
    t.integer  "muscle_group_1_goal_achieved", :default => 0
    t.integer  "muscle_group_2_goal_achieved", :default => 0
    t.integer  "mg1_phase_attempt_counter",    :default => 1
    t.integer  "mg2_phase_attempt_counter",    :default => 1
    t.integer  "mg1_perodize_phase",           :default => 1
    t.integer  "mg2_perodize_phase",           :default => 1
  end

end
