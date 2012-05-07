class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :institute_id
      t.date :start
      t.date :end
      t.boolean :current

      t.timestamps
    end
  end
end
