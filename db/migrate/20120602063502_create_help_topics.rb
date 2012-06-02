class CreateHelpTopics < ActiveRecord::Migration
  def change
    create_table :help_topics do |t|
      t.integer :order
      t.string :name

      t.timestamps
    end
  end
end
