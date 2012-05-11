class CreateTeacherSections < ActiveRecord::Migration
  def change
    create_table :teacher_sections do |t|
      t.integer :institute_id
      t.integer :user_id
      t.integer :section_id

      t.timestamps
    end
  end
end
