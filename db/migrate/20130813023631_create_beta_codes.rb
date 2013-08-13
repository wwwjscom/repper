class CreateBetaCodes < ActiveRecord::Migration
  def change
    create_table :beta_codes do |t|
      t.string :code
      t.boolean :used, :default => false
      t.string :assigned_to_email, :default => nil

      t.timestamps
    end
  end
end
