class CreateExamResults < ActiveRecord::Migration
  def change
    create_table :exam_results do |t|
      t.integer :exam_id
      t.integer :user_id
      t.integer :course_id
      t.integer :section_id
      t.integer :score

      t.timestamps
    end
  end
end
