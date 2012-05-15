class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :task_type
      t.string :status
      t.string :comment
      t.integer :institute_id

      t.timestamps
    end
  end
end
