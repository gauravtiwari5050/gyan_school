class CreateDefaultSubjects < ActiveRecord::Migration
  def change
    create_table :default_subjects do |t|
      t.string :name

      t.timestamps
    end
  end
end
