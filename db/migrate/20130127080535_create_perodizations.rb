class CreatePerodizations < ActiveRecord::Migration
  def change
    create_table :perodizations do |t|
      t.integer :user_id
      t.integer :muscle_group_id
      t.integer :perodization_phase

      t.timestamps
    end
  end
end
