class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :institute_id
      t.string :name

      t.timestamps
    end
  end
end
