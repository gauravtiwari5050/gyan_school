class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.string :name
      t.date :start
      t.date :end
      t.references :examable,:polymorhic => true

      t.timestamps
    end
  end
end
