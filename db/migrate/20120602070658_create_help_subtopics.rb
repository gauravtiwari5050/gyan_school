class CreateHelpSubtopics < ActiveRecord::Migration
  def change
    create_table :help_subtopics do |t|
      t.integer :help_topic_id
      t.integer :order
      t.text :content
      t.string :support_file

      t.timestamps
    end
  end
end
