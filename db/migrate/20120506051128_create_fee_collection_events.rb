class CreateFeeCollectionEvents < ActiveRecord::Migration
  def change
    create_table :fee_collection_events do |t|
      t.integer :institute_id
      t.string :name
      t.date :due_date

      t.timestamps
    end
  end
end
