class ModifyCourses < ActiveRecord::Migration

  def change
   rename_column :courses, :institute_id, :batch_id
  end
end
