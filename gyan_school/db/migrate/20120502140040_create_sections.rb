class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :batch_id
      t.string :name

      t.timestamps
    end
  end
end
