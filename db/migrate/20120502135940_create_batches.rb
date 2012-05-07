class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.integer :institute_id
      t.string :name

      t.timestamps
    end
  end
end
