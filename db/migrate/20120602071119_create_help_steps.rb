class CreateHelpSteps < ActiveRecord::Migration
  def change
    create_table :help_steps do |t|
      t.integer :help_subtopic_id
      t.integer :order
      t.string :title
      t.text :content
      t.string :support_file
      t.string :support_image

      t.timestamps
    end
  end
end
