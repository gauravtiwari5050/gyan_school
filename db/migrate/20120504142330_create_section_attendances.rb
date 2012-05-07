class CreateSectionAttendances < ActiveRecord::Migration
  def change
    create_table :section_attendances do |t|
      t.integer :section_id
      t.integer :institute_session_id
      t.integer :user_id

      t.timestamps
    end
  end
end
