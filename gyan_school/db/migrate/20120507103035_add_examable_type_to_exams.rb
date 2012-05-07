class AddExamableTypeToExams < ActiveRecord::Migration
  def change
    add_column :exams, :examable_type, :string

  end
end
